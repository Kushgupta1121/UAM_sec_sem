%%1.1.1 Exercise 1: Computation of the planar homographies
clc;
clear all;
close all;

% Using get_real_points_checkerboard_vmmc function to obtain an array with the coordinates of the 
% marked points XY, center at top left corner (marked point 7)

% uncomment to run task 1-2 using the given pattern Images
[coords, ima_pattern]= get_real_points_checkerboard_vmmc(9,320,1);
 
% uncomment to run task 1-2 using the Users Images
%[coords, ima_pattern]= get_real_points_checkerboard_vmmc(9,500,1);

%% To load the 5 Fixed Checker Board Images into a Matrix of (:,:,5)
% uncomment to run task 1-2 using the given pattern Images
new_dir = "/Users/kushgupta/Documents/MATLAB/VMMC_LAB/LA2_Files/FixedCamera_Data";

% uncomment to run task 1-2 using the Users Images
%new_dir = "/Users/kushgupta/Documents/MATLAB/VMMC_LAB/LA2_Files/my_images";

img_mat=[];

for k = 1:5
    % uncomment to run task 1-2 using the given pattern Images
 input_img = sprintf('PatternImage_Orientation_%d.bmp', k);

 % uncomment to run task 1-2 using the Users Images
%input_img = sprintf('Img_%d.jpeg', k);
  fullFileName = fullfile(new_dir, input_img);
  if exist(fullFileName, 'file')
    % for the first part 
    imageData = imread(fullFileName);
    %for second part
    %imageData = imresize(im2gray(imread(fullFileName)),[512 512]);
  else
    warningMessage = sprintf('Warning: image file does not exist:\n%s', fullFileName);
    uiwait(warndlg(warningMessage));
  end
img_mat(:,:,k)=imageData;
figure(k);
imshow(imageData);
end
img_mat=uint8(img_mat);

%% Getting user points on the Provided Images
xy=[];
for i=1:5
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

for j = 1:5
    input_img=img_mat(:,:,j) ;
    xy_target=xy(:,:,j);
% Calculating the Homography Matrix using the homography_solve_vmmc
% function
H{j}=homography_solve_vmmc(xy_origin,xy_target);

% Creating the transform
%tfrom=maketform('projective',H{j}');

% Resulted Image using the tform
%output_img{j}=imtransform(ima_pattern,tfrom);

%Plotting the Transformed Image
%figure(j);
%imshow(output_img);
%imshow((output_img{j}));
%title('Restored Image');

end

%% Zang's method: Refining the obtained homographies using iterative minimization of cummulative geometric error
H_out={};
rperr=[];
new_output_img={};
for l=1:5
    %disp('calling the refine VMMC Function');
    [H_out{l}, rperr(l)] = homography_refine_vmmc(xy_origin,xy(:,:,l), H{l});

    % Creating the transform
    tfrom_new=maketform('projective',H_out{l}');

    % Resulted Image using the tform
    new_output_img{l}=imtransform(ima_pattern,tfrom_new);

    %Plotting the Transformed Image
    figure(l);
    %imshow(output_img);
    imshow((new_output_img{l}));
    title('New Restored Image');

end
%===============
% to show fig 
%{
for o=1:size(img_mat,3)

    figure(o);
    imshow((new_output_img{o}));
end
%}