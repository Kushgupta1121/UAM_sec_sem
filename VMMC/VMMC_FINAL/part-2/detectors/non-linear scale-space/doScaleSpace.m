%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VIDEO FOR MULTIPLE AND MOVING CAMERAS (VMMC)
% IPCV @ UAM
% Marcos Escudero-Viñolo (marcos.escudero@uam.es)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SS=doScaleSpace(I,nscales,t0)

%% Initialize scale-space structure
[nr,nc]     = size(I);
if min(nr,nc) == 1
    onedim =true;
else
    onedim = false;
end
SS          = cell(1, nscales);
SS{1}       = double(I);
%% define Gaussian filter
sigma = sqrt(t0);
g     = createGaussianKernel(nr,nc,sigma);
%% obtain scale-space representation guided by the Gaussian filter
for j = 2:1:(nscales)
    if ~onedim
    SS{j} =  imfilter(imfilter(SS{j-1},g,'symmetric','same'),g','symmetric','same');
    else
    SS{j} =  imfilter(SS{j-1},g,'symmetric','same');
    end
end

end
