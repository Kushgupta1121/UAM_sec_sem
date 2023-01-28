function [ d ] = compute_scharr_derivatives(input, dx,dy, t)
%% Compute_scharr_derivatives(input, dx,dy, scale)
% Computes the Scharr derivatives
% input: image input
% dx: 0 or 1
% dy: 0 or 1
% scale: scale of the non-linear scale space, use 1 for normal scharr
% derivatives

% Get the appropiate kernel
F    = compute_derivative_kernels(dx,dy,sqrt(t));
% Filter the image
d    = imfilter(input,F,'same','replicate');
end

