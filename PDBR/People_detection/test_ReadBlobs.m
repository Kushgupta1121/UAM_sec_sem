clear all
close all
clc

video_dir='./Videos';
video_names={'tud-campus-sequence'};

model_id='Inria';


threshold=-1.50;
debug_threshold=-1.65;

for i=1:size(video_names,2)    
    filename=sprintf('%s/%s/%s_dtdp_%s_thr%.2f.idl',video_dir,video_names{i},video_names{i},model_id,threshold);
	video_list=sprintf('%s/%s/dataIn.txt',video_dir,video_names{i});
    fid=fopen(video_list,'r');
    num_images=0;
    cadena=fgets(fid);
    while(size(cadena,2)>4)
        num_images=num_images+1;
        cadena=fgets(fid);
    end
    fclose(fid);
    
    [Blobs]=ReadBlobs(filename,video_names{i});
    Blobs=Blobs_Threshold(Blobs,debug_threshold);
    figure
    for frame=1:1:num_images
        cadena=sprintf('%s/%s/%s-%.3d.png',video_dir,video_names{i},video_names{i},frame); 
        imagen=imread(cadena);
        if(size(Blobs,2)>=frame)
            imagen=PaintBlobs(Blobs{frame},imagen,[0 255 0]);
        end
        imshow(imagen)
        cadena=sprintf('%s/%s/%s-%.3d_out.png',video_dir,video_names{i},video_names{i},frame); 
        imwrite(imagen,cadena)
        aux=sprintf('Frame: %d of %d',frame,num_images); 
        title (aux)
        disp(aux)
        pause(0.001);
    end

end