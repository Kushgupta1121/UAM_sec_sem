%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VIDEO FOR MULTIPLE AND MOVING CAMERAS (VMMC)
% IPCV @ UAM
% Marcos Escudero-Viñolo (marcos.escudero@uam.es)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [k] = compute_kcontrast(ima,t,perc)
%  This function computes a good empirical value for the k contrast factor
%  given an input image, the percentile (0-1) and the gradient scale
%
%  INPUTS:
%       - img    = grayscale image
%       - perc   = percentile
%       - t0     = scale at which to extract the derivative
%% Obtain partial smoothed derivatives
%% op 1) Directional derivatives based on scharr
% Lx = compute_scharr_derivatives(ima, 1,0, t);
% Ly = compute_scharr_derivatives(ima, 0,1, t);
%% op 2) Directional Gaussian derivatives
dg = DerivativeGaussianKernel(sqrt(t),1);
Lx = imfilter(ima,dg','symmetric','same');
Ly = imfilter(ima,dg,'symmetric','same');
% Gradient magnitude
M  = sqrt(Lx.*Lx + Ly.*Ly);
k  = prctile(M(:),perc.*100);
