clear all
close all
clc
%% parameters (example)
sigma   = sqrt(2); % gaussian filter standard deviation
perc    = 0.7;     % percentil for k-contrast
%% read some image and convert to gray and double [0,1]
ima = im2double(imread('peppers.png'));
[nr,nc,nch] = size(ima);
if nch > 1
ima = rgb2gray(ima);
nch = 1;
end
%% Gaussian smooothing
g          =  createGaussianKernel(nr,nc,sigma);
ima_smooth =  imfilter(imfilter(ima,g,'symmetric','same'),g','symmetric','same');
%% Get k contrast
[k] = compute_kcontrast(ima_smooth,perc);
%% Get conductivities
psi_c = 1;
psi_1=getConductivity(ima_smooth,psi_c,k,1);
psi_c = 2;
psi_2=getConductivity(ima_smooth,psi_c,k,1);
psi_c = 3;
psi_3=getConductivity(ima_smooth,psi_c,k,1);
%% show conductivities
figure(1),
subplot_tight(1,2,1),imshow(ima);title('Original image');
subplot_tight(1,2,2),imshow(psi_1);title(sprintf('Conductivity %s','\psi_1'));
figure(2),
subplot_tight(1,2,1),imshow(ima);title('Original image');
subplot_tight(1,2,2),imshow(psi_2);title(sprintf('Conductivity %s','\psi_2'));
figure(3),
subplot_tight(1,2,1),imshow(ima);title('Original image');
subplot_tight(1,2,2),imshow(psi_3);title(sprintf('Conductivity %s','\psi_3'));
figure(4),
subplot_tight(2,2,1),imshow(ima);title('Original image');
subplot_tight(2,2,2),imshow(psi_1);title(sprintf('Conductivity %s','\psi_1'));
subplot_tight(2,2,3),imshow(psi_2);title(sprintf('Conductivity %s','\psi_2'));
subplot_tight(2,2,4),imshow(psi_3);title(sprintf('Conductivity %s','\psi_3'));
