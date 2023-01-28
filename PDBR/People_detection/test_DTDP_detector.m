clear all
close all
clc

video_dir='./Videos';


video_dir='./Videos';
video_names={'tud-campus-sequence'};
%video_names={'fall','office','overpass'}; %'abandonedBox','backdoor','badminton','busStation','copyMachine','cubicle',


model_filename='./DTDP detector/voc-release4.01_windows32bit/INRIA/inriaperson_final.mat';
model_id='Inria';
threshold=-1.5;

 %model_filename='./DTDP detector/voc-release4.01_windows32bit/VOC2009/person_final.mat';
 %model_id='VOC2009';


for i=1:size(video_names,2)
    video_list=sprintf('%s/%s/dataIn.txt',video_dir,video_names{i});
    fid=fopen(video_list,'r');
    num_images=0;
    cadena=fgets(fid);
    images_names={};
    while(size(cadena,2)>4)
        num_images=num_images+1;
        index=find((cadena==' ' | cadena==char(13))==1);
        if(~isempty(index))
            images_names{num_images}=cadena(1:index(1)-1);
        else
            images_names{num_images}=cadena;
        end
        cadena=fgets(fid);

    end
    fclose(fid);
    DTDP_detector(images_names,threshold,video_names{i},video_dir,model_filename,model_id);    
end


