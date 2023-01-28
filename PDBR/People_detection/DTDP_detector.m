
function DTDP_detector(images_names,threshold,video,video_dir,model_filename,model_id)

addpath('./DTDP detector/voc-release4.01_windows32bit');
load(model_filename);
 
for i=1:size(images_names,2)
    aux=sprintf('%s/%s',video_dir,images_names{i});  
    test(aux, model,model_id,images_names{i},threshold,video,video_dir,i);  
    aux=sprintf('Video: %s Frame %d of %d',video,i,size(images_names,2));    
    disp(aux);
end
clear model

function test(name, model,model_id,image_name,threshold,video,video_dir,num_frame)

im = imread(name);
[dets, boxes] = imgdetect(im, model, threshold);


overlap=0.5;
top = nms(dets, overlap);
if(~isempty(top))  
    bbox = bboxpred_get(model.bboxpred, dets, reduceboxes(model, boxes));
    bbox = clipboxes(im, bbox);
    top = nms(bbox, overlap);
    final_blobs=bbox(top,:);
else
    final_blobs=[];
end
out_filename=sprintf('%s/%s/%s_dtdp_%s_thr%.2f.idl',video_dir,video,video,model_id,threshold);
if(num_frame==1)
    fid=fopen(out_filename,'w+');
    fclose(fid);
end
if numel(final_blobs)~=0
    final_blobs(:,3)=final_blobs(:,3)-final_blobs(:,1);
    final_blobs(:,4)=final_blobs(:,4)-final_blobs(:,2);
    
end
save_blobs(final_blobs,name,out_filename);
clear top clear bbox
clear final_blobs

    

