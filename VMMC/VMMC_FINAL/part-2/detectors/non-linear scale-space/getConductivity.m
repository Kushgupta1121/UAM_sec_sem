%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VIDEO FOR MULTIPLE AND MOVING CAMERAS (VMMC)
% IPCV @ UAM
% Marcos Escudero-Viñolo (marcos.escudero@uam.es)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c=getConductivity(ima,psi_c,k,t)

%% op 1) Directional derivatives based on scharr
% Lx = compute_scharr_derivatives(ima, 1,0, t0);
% Ly = compute_scharr_derivatives(ima, 0,1, t0);
%% op 2) Directional Gaussian derivatives
dg = DerivativeGaussianKernel(sqrt(t),1);
Lx = imfilter(ima,dg','symmetric','same');
Ly = imfilter(ima,dg,'symmetric','same');
%% Gradient magnitude
M  = sqrt(Lx.*Lx + Ly.*Ly);

% Conductivity psi
switch psi_c
    case 1
         c          = exp(-(M.^2)./(k*k));
    case 2
         c          = 1./(1+(M.^2)./(k*k));
    case 3
         c          = 1 - exp(-3.315./((M.^2)./(k*k)));
         c(M < eps) = 1;
    otherwise
        c          = 1 - exp(-3.315./((M.^2)./(k*k)));
        c(M < eps) = 1;
end

end