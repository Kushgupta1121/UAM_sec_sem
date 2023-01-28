clc;
clear all;
close all;

load ('part1.mat')
% Using get_real_points_checkerboard_vmmc function to obtain an array with the coordinates of the 
% marked points XY, center at top left corner (marked point 7)

% uncomment to run task 1-2 using the given pattern Images
[coords, ima_pattern]= get_real_points_checkerboard_vmmc(9,320,1);

%% To load the 7 Fixed Checker Board Images into a Matrix of (:,:,7)
% uncomment to run task 1-2 using the given pattern Images
new_dir = "vmmc_1080p";

img_mat=[];
%org_img=[];
for k = 1:6
 % uncomment to run task 1-2 using the Users Images
input_img = sprintf('1080_%d.jpg', k);
  fullFileName = fullfile(new_dir, input_img);
  if exist(fullFileName, 'file')
    %imageData = imresize(im2gray(imread(fullFileName)),[1024 1024]);
     imageData = im2gray(imread(fullFileName));

  else
    warningMessage = sprintf('Warning: image file does not exist:\n%s', fullFileName);
    uiwait(warndlg(warningMessage));
  end
img_mat(:,:,k)=imageData;
%org_img(:,:,k)=imageData;
figure(k);
imshow(imageData);
end
img_mat=uint8(img_mat);

%% Getting user points on the Provided Images
xy=[];
for i=1:6
    img=img_mat(:,:,i);
    xy(:,:,i) = get_user_points_vmmc(img);
    %figure(1);
    %imshow(img);
end

%% Calculating Homography for Images:

output_img = {size(img_mat,3)}; 
H={};
xy_origin = coords';
xy_target = [];

for j = 1:6
    input_img=img_mat(:,:,j) ;
    xy_target=xy(:,:,j);
% Calculating the Homography Matrix using the homography_solve_vmmc
% function
H{j}=homography_solve_vmmc(xy_origin,xy_target);
end
%% Zang's method: Refining the obtained homographies using iterative minimization of cummulative geometric error
H_out={};
rperr=[];
new_output_img={};
for l=1:6
    %disp('calling the refine VMMC Function');
    [H_out{l}, rperr(l)] = homography_refine_vmmc(xy_origin,xy(:,:,l), H{l});

    % Creating the transform
    tfrom_new=maketform('projective',H_out{l}');

    % Resulted Image using the tform
    new_output_img{l}=imtransform(ima_pattern,tfrom_new);

    %Plotting the Transformed Image
    %figure(l);
    %imshow((new_output_img{l}));
    %title('New Restored Image');

end
%===============
% to show fig 

for o=1:6
    title('Result')
    %subtitle('Original Image')
    figure(o);
    %subplot(1,2,1)
    %imshow(img_mat(:,:,o));
    %subtitle('Checkerboard Image')
    %subplot(1,2,2)
    imshow((new_output_img{o}));
end


A = internal_parameters_solve_vmmc(H_out);

save part1.mat




