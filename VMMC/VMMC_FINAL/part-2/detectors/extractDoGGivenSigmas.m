function DoG  = extractDoGGivenSigmas(SS, sigmas, noctaves, nscales)
DoG = zeros(size(SS{1},1),size(SS{1},2),numel(SS)-nscales);
i=1;
for j=1:numel(SS)-1

    normf      = sigmas(j).^2;% t
    delta = (sigmas(j+1).^2) - (sigmas(j).^2);% delta_t
    
    T = normf./delta;
    if mod(j, nscales)~=0
    DoG(:,:,i) = T*(SS{j+1}-SS{j});    
    i=i+1;
    end
end
end