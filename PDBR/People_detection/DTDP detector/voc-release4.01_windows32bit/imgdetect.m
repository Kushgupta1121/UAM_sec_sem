function [dets, boxes, info] = imgdetect(input, model, thresh,Levels, bbox, overlap)

% Wrapper that computes detections in the input image.
%
% input    input image
% model    object model
% thresh   detection score threshold
% bbox     ground truth bounding box
% overlap  overlap requirement

% we assume color images
input = color(input);

if nargin<4
    Levels=[1:100];
end

% get the feature pyramid
pyra = featpyramid(input, model,Levels);

if nargin < 5
  bbox = [];
end

if nargin < 6
  overlap = 0;
end

[dets, boxes, info] = gdetect(pyra, model, thresh, bbox, overlap);
