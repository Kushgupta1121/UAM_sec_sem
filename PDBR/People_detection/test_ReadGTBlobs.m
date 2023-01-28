clear all
close all
clc

video_dir='./Videos';
video_names={'tud-campus-sequence'};

for i=1:size(video_names,2)
    filename_gt=sprintf('%s/%s/%sgt.txt',video_dir,video_names{i},video_names{i});
    video_list=sprintf('%s/%s/dataIn.txt',video_dir,video_names{i});
    fid=fopen(video_list,'r');
    num_images=0;
    aux=fgets(fid);
    while(size(aux,2)>4)
        num_images=num_images+1;
        aux=fgets(fid);
    end
    fclose(fid);
    
    [Blobs]=ReadGTBlobs(filename_gt,video_names{i});
    figure
    for frame=1:1:num_images
        aux=sprintf('%s/%s/%s-%.3d.png',video_dir,video_names{i},video_names{i},frame); 
        imagen=imread(aux);
        if(size(Blobs,2)>=frame)
            imagen=PaintBlobs(Blobs{frame},imagen,[0 255 0]);
        end
        imshow(imagen)
        aux=sprintf('%s/%s/%s-%.3d_gt_out.png',video_dir,video_names{i},video_names{i},frame); 
        imwrite(imagen,aux)
        aux=sprintf('Video: %s Frame %d of %d',video_names{i},frame,num_images); 
        title(aux)
        disp(aux);
        pause(0.001);
    end
end

