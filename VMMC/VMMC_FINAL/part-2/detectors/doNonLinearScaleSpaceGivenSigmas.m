function NLSS = doNonLinearScaleSpaceGivenSigmas(ima,sigmas,perc,psi_c)
%% Get smoothed image
[nr,nc]       = size(ima);
g             = createGaussianKernel(nr,nc,sqrt(sigmas(1)));
ima_s         = imfilter(imfilter(ima,g,'symmetric','same'),g','symmetric','same');
%% Get k contrast
[k]           =  compute_kcontrast(ima_s,sigmas(1),perc);
%% Initialize scale-space structure
NLSS          = cell(1, numel(sigmas));
NLSS{1}       = ima_s; % the first scale is the smoothed image
%% obtain non-linear scale-space representation guided by the conductivity function via aoiso
for j = 2:1:numel(sigmas)
    %% Get conductivity
    c       = getConductivity(NLSS{1},psi_c,k,sigmas(j)^2);
    %%
    figure(1),clf,imagesc(c),title(sprintf('Conductivity at scale: %.2f',sigmas(j)^2));pause(0.01);
    %% Get next scale
    NLSS{j} = aosiso(NLSS{j-1}, c, (sigmas(j)) - (sigmas(j-1)));
end

end