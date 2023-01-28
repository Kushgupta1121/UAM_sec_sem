%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VIDEO FOR MULTIPLE AND MOVING CAMERAS (VMMC)
% IPCV @ UAM
% Marcos Escudero-Viñolo (marcos.escudero@uam.es)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clf
clc
% warning off
%% parameters (example)
t0      =   2;    % initial scale
perc    = 0.7;     % percentil for k-contrast
nscales = 50;     % number of scales
psi_c   = 2;       % type of conductivity function
%% read some image and convert to gray and double [0,1]
ima = im2double(imread('peppers.png'));
[nr,nc,nch] = size(ima);
if nch > 1
ima = rgb2gray(ima);
nch = 1;
end
%% Build non linear scale-space
NLSS = doNonLinearScaleSpace(ima,nscales,perc,psi_c,t0);
%% Build linear scale-space (for comparison)
SS   = doScaleSpace(ima,nscales,t0);
%% show non-linear two-dimensional scale space
for j = 1:1:nscales
    figure(1),clf
    subplot_tight(2,2,1),imshow(NLSS{j});
    title(sprintf('Non-linear Scale: %d',j));
    subplot_tight(2,2,2),imshow(SS{j});
    title(sprintf('Linear Scale: %d',j));
    subplot_tight(2,2,3),surf(NLSS{j},'EdgeColor','None');colormap(gray);
    ax = gca; ax.XDir = 'reverse';axis tight; 
    view(-165,75)
    title(sprintf('Non-linear Scale: %d',j));
    subplot_tight(2,2,4),surf(SS{j},'EdgeColor','None');colormap(gray);
    ax = gca; ax.XDir = 'reverse';axis tight; 
    view(-165,75)
    title(sprintf('Linear Scale: %d',j));
    pause(0.01);
end 
