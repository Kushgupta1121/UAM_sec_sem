function [ kernel ] = compute_derivative_kernels(dx,dy,scale)
%This function computes the scharr kernel derivatives depending on the 
% scale and direction of the derivative
%% If the scale is the first, the normal scharr kernel is generated
if (scale == 1)
    temp = [-3 0 3; -10 0 10; -3 0 3];
    if dx
        kernel = temp;
    elseif dy
        kernel = temp';
    end
    return;
end
%% If not, compute the kernel depending on the scale
ksize = 3+2*(scale-1);
w     = 10/3;
norm  = 1/(2*scale*(w+2));

for k = 0:1
    
    kerI = zeros(ksize,1);
    
    if k == 0
        order = dx;
    else
        order = dy;
    end
    
    if order == 0
        kerI(1) = norm;
        kerI(ceil(ksize/2)) = w*norm;
        kerI(ksize) = norm;  
    elseif order == 1
        kerI(1) = -1;
        kerI(ceil(ksize/2)) = 0;
        kerI(ksize) = 1;
    end
    
    if k == 0
        kx = kerI;
    else
        ky = kerI;
    end
    
end
%% Span the kernel by multiplying the two orthogonal vectors
kernel = kx*ky';
end

