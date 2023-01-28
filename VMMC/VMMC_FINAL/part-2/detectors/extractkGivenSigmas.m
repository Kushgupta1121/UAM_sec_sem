function DoH  = extractkGivenSigmas(SS,sigmas)

DoH = zeros(size(SS{1},1),size(SS{1},2),numel(SS));
for j=1:numel(SS)
   
    
    dggxx   = ndgauss([size(SS{j},1) size(SS{j},2)],[sigmas(j),sigmas(j)],'der',[2 0]);
    Lxx    = imfilter(SS{j},dggxx,'symmetric','same');
    
    dggyy   = ndgauss([size(SS{j},1) size(SS{j},2)],[sigmas(j),sigmas(j)],'der',[0 2]);
    Lyy    = imfilter(SS{j},dggyy,'symmetric','same');
    
    dggxy   = ndgauss([size(SS{j},1) size(SS{j},2)],[sigmas(j),sigmas(j)],'der',[1 1]);%,'normalize',1);
    Lxy   = imfilter(SS{j},dggxy,'symmetric','same');
    
    dggx   = ndgauss([size(SS{j},1) size(SS{j},2)],[sigmas(j),sigmas(j)],'der',[1 0]);%,'normalize',1);
    Lx = imfilter(SS{j},dggx,'symmetric','same');
    
    dggy   = ndgauss([size(SS{j},1) size(SS{j},2)],[sigmas(j),sigmas(j)],'der',[0 1]);%,'normalize',1);
    Ly = imfilter(SS{j},dggy,'symmetric','same');

    
    normf = ((sigmas(j)).^3);% t^(3/2)
    DoH(:,:,j)= normf.*(Lx.*Lx.*Lyy + Ly.*Ly.*Lxx - 2*Lx.*Ly.*Lxy);
    
end