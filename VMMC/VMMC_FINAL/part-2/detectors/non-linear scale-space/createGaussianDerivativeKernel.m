function g = createGaussianDerivativeKernel(nr,nc,sigma,order)
%% define Gaussian filter
% one or two dimensional signal?
if min(nr,nc) == 1
    dim = max(nr,nc);
else
    dim = min(nr,nc);
end
% define with center
if rem(dim,2) == 0
    dim = dim+1;
end
g   = fspecial('gaussian',[dim,1],sigma);
t   = -floor(dim/2):floor(dim/2);
% Scale the t-vector, what we actually do is H( t/(sigma*sqrt2) ), where H() is the
% Hermite polynomial. 
x = t / (sigma*sqrt(2));
% derivative order (1 -> 1st derivate, 2 -> 2nd derivative,...)
switch order
    case 0,  part = 1;
    case 1,  part = 2*x;
    case 2,  part = -2 + 4*x.^2;
    case 3,  part = -12*x + 8*x.^3;
    case 4,  part = 12 - 48*x.^2 + 16*x.^4;
    case 5,  part = 120*x - 160*x.^3 + 32*x.^5;
    case 6,  part = -120 + 720*x.^2 - 480*x.^4 + 64*x.^6;
    case 7,  part = -1680*x + 3360*x.^3 - 1344*x.^5 + 128*x.^7;
    case 8,  part = 1680 - 13440*x.^2 + 13440*x.^4 - 3584*x.^6 + 256*x.^8;
    case 9,  part = 30240*x - 80640*x.^3 + 48384*x.^5 - 9216*x.^7 + 512*x.^9;
    case 10,  part = -30240 + 302400*x.^2 - 403200*x.^4 + 161280*x.^6 - 23040*x.^8 + 1024*x.^10;
    case 11,  part = -665280*x + 2217600*x.^3 - 1774080*x.^5 + 506880*x.^7 - 56320*x.^9 + 2048*x.^11;
    case 12,  part = 665280 - 7983360*x.^2 + 13305600*x.^4 - 7096320*x.^6 + 1520640*x.^8 - 135168*x.^10 + 4096*x.^12;
    case 13,  part = 17297280*x - 69189120*x.^3 + 69189120*x.^5 - 26357760*x.^7 + 4392960*x.^9 - 319488*x.^11 + 8192*x.^13;
    case 14,  part = -17297280 + 242161920*x.^2 - 484323840*x.^4 + 322882560*x.^6 - 92252160*x.^8 + 12300288*x.^10 - 745472*x.^12 + 16384*x.^14;
    case 15,  part = -518918400*x + 2421619200*x.^3 - 2905943040*x.^5 + 1383782400*x.^7 - 307507200*x.^9 + 33546240*x.^11 - 1720320*x.^13 + 32768*x.^15;
    case 16,  part = 518918400 - 8302694400*x.^2 + 19372953600*x.^4 - 15498362880*x.^6 + 5535129600*x.^8 - 984023040*x.^10 + 89456640*x.^12 - 3932160*x.^14 + 65536*x.^16;
    case 17,  part = 17643225600*x - 94097203200*x.^3 + 131736084480*x.^5 - 75277762560*x.^7 + 20910489600*x.^9 - 3041525760*x.^11 + 233963520*x.^13 - 8912896*x.^15 + 131072*x.^17;
    case 18,  part = -17643225600 + 317578060800*x.^2 - 846874828800*x.^4 + 790416506880*x.^6 - 338749931520*x.^8 + 75277762560*x.^10 - 9124577280*x.^12 + 601620480*x.^14 - 20054016*x.^16 + 262144*x.^18;
    case 19,  part = -670442572800*x + 4022655436800*x.^3 - 6436248698880*x.^5 + 4290832465920*x.^7 - 1430277488640*x.^9 + 260050452480*x.^11 - 26671841280*x.^13 + 1524105216*x.^15 - 44826624*x.^17 + 524288*x.^19;
    case 20,  part = 670442572800 - 13408851456000*x.^2 + 40226554368000*x.^4 - 42908324659200*x.^6 + 21454162329600*x.^8 - 5721109954560*x.^10 + 866834841600*x.^12 - 76205260800*x.^14 + 3810263040*x.^16 - 99614720*x.^18 + 1048576*x.^20;
    otherwise error([mfilename ': derivative of that order not defined']);
end
% apply Hermite polynomial to gauss
g = (-1).^order .* part .* g;
%% NORMALIZE
g = g./sum(g);
%% Truncate filter_mask to non-zero elements
g   = g(g~=0);