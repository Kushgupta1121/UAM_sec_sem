%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VIDEO FOR MULTIPLE AND MOVING CAMERAS (VMMC)
% IPCV @ UAM
% Marcos Escudero-Viñolo (marcos.escudero@uam.es)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NLSS = doNonLinearScaleSpace(ima,nscales,perc,psi_c,t0)
%% Get smoothed image
[nr,nc]       = size(ima);
g             = createGaussianKernel(nr,nc,sqrt(t0));
ima_s         = imfilter(imfilter(ima,g,'symmetric','same'),g','symmetric','same');
%% Get k contrast
[k]           =  compute_kcontrast(ima_s,t0,perc);
%% Initialize scale-space structure
NLSS          = cell(1, nscales);
NLSS{1}       = ima_s; % the first scale is the smoothed image
%% obtain non-linear scale-space representation guided by the conductivity function via aoiso
for j = 2:1:nscales
    %% Get conductivity
    c       = getConductivity(NLSS{1},psi_c,k,j*t0);
    %%
    figure(1),clf,imagesc(c),title(sprintf('Conductivity at scale: %.2f',j.*t0));pause(0.01);
    %% Get next scale
    NLSS{j} = aosiso(NLSS{j-1}, c, (sqrt(j.*t0)) - (sqrt((j-1).*t0)));
end

end