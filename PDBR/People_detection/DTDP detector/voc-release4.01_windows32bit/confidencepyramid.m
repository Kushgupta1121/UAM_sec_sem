%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pyra_confidence_weights = confidencepyramid(im, model,confidence_maps, padx, pady)
%
%   Inputs
%   im:Input image (original input size)
%   model:Person detector model with N parts (root + N-1 body parts) 
%   confidence_maps: Confidence maps array N maps x (original input image size)
%
%   Outputs
%   pyra_confidence_weights
%   pyra.pyra_confidence_weights{n}{i} confidence map of body part n at the i-th scale level of the pyramid.
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pyra_confidence_weights = confidencepyramid(im, model,confidence_maps)


%Initializaction
[padx, pady] = getpadding(model);
sbin = model.sbin;
interval = model.interval;
sc = 2 ^(1/interval);
imsize = [size(im, 1) size(im, 2)];
max_scale = 1 + floor(log(min(imsize)/(5*sbin))/log(sc));
pyra_imsize = imsize;
pyra_confidence_maps=cell(max_scale + interval, 1);  
pyra_confidence_maps_inv=cell(max_scale + interval, 1);
N_parts=size(confidence_maps,2);
for n=1:N_parts
    confidence_scaled{n}=cell(max_scale + interval, 1);    
end
confidence_scaled=cell(1,N_parts);

%Confidence maps pyramid
for i = 1:interval

  % "first" 2x interval
  pyra_confidence_maps{i}=[];
  pyra_confidence_maps_inv{i}=[];      
  for n=1:N_parts     
      confidence_aux=zeros(size(confidence_maps{n},1),size(confidence_maps{n},2),3);
      confidence_aux(:,:,1)=confidence_maps{n};
      confidence_aux(:,:,2)=confidence_maps{n};
      confidence_aux(:,:,3)=confidence_maps{n};
      %our resize function wants floating point values
      confidence_aux=double(confidence_aux);
      confidence_scaled{n}{i} = resize(confidence_aux, (2/sc^(i-1))/sbin);  
      if(n==1)
          pyra_confidence_maps{i}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
          pyra_confidence_maps_inv{i}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
      end
      pyra_confidence_maps{i}(:,:,n)=rgb2gray(confidence_scaled{n}{i});
      pyra_confidence_maps_inv{i}(:,:,n)=1-rgb2gray(confidence_scaled{n}{i});
  end  
  
  % "second" 2x interval
  for n=1:N_parts
      %our resize function wants floating point values
      confidence_scaled{n}{i}=double(confidence_scaled{n}{i});
      confidence_scaled{n}{i} = resize(confidence_scaled{n}{i}, 0.5); 
      if(n==1)
          pyra_confidence_maps{i+interval}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
          pyra_confidence_maps_inv{i+interval}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
      end
      pyra_confidence_maps{i+interval}(:,:,n)=rgb2gray(confidence_scaled{n}{i});
      pyra_confidence_maps_inv{i+interval}(:,:,n)=1-rgb2gray(confidence_scaled{n}{i});
      confidence_scaled_aux=[];
  end
   
  % remaining interals
  for j = i+interval:interval:max_scale     
      for n=1:N_parts
           %our resize function wants floating point values
          confidence_scaled{n}{i}=double(confidence_scaled{n}{i});
          confidence_scaled{n}{i} = resize(confidence_scaled{n}{i}, 0.5);  
          if(n==1)
              pyra_confidence_maps{j+interval}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
              pyra_confidence_maps_inv{j+interval}=zeros(size(confidence_scaled{n}{i},1),size(confidence_scaled{n}{i},2),8);
          end
          pyra_confidence_maps{j+interval}(:,:,n)=rgb2gray(confidence_scaled{n}{i});
          pyra_confidence_maps_inv{j+interval}(:,:,n)=1-rgb2gray(confidence_scaled{n}{i});
          confidence_scaled_aux=[];
      end
  end
end

%Combination body parts weights
for i = 1:max_scale + interval
    for n=1:N_parts
        max_weights=zeros(size(pyra_confidence_maps_inv{i},1),size(pyra_confidence_maps_inv{i},2),N_parts);
        for k=1:size(pyra_confidence_maps_inv{i},1)
            for kk=1:size(pyra_confidence_maps_inv{i},2)
                max_weights(k,kk,:)=max(pyra_confidence_maps_inv{i}(k,kk,:));
            end
        end
        normalized_weights=pyra_confidence_maps_inv{i}(:,:,:)./max_weights;
        weight_update_mask=normalized_weights==0;      
        weight_degrade_mask=normalized_weights~=0;      
%         weights=normalized_weights.*weight_update_mask;      
        weights=normalized_weights;  

        weight_update=abs(((sum(normalized_weights,3))./(sum(weight_update_mask(:,:,:),3))));
        weight_update_mask_aux=weight_update_mask(:,:,n);
        weight_update_mask_aux(weight_update==inf | isnan(weight_update))=1;
        normalized_weights_aux=normalized_weights(:,:,n);
        normalized_weights_aux(weight_update==inf | isnan(weight_update))=1;
        weight_update(weight_update==inf | isnan(weight_update))=normalized_weights_aux(weight_update==inf | isnan(weight_update));

        pyra_confidence_weights{n}{i}=1-(max_weights(:,:,n).*normalized_weights_aux)+max_weights(:,:,n).*weight_update.*weight_update_mask_aux;
    end

    %Check everything==1
    check_sum=zeros(size(pyra_confidence_maps{i},1),size(pyra_confidence_maps{i},2));
    for n=1:N_parts
        check_sum=check_sum+pyra_confidence_weights{n}{i};
    end
    if (round(sum(sum(check_sum/N_parts)))~=size(pyra_confidence_maps{i},1)*size(pyra_confidence_maps{i},2))
        printf('Error checksum pyra_confidence_weights');
        pause;      
    end
end
