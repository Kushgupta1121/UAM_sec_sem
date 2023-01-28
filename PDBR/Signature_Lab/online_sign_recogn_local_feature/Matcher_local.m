function Score=Matcher_local(test,Model)
% Function to match local features using the DTW

score=0;
T=size(Model,2)*size(Model,1);

for i = 1:size(Model,1)
    model= Model(i,:) ;
    for j=1:length(model)
        [D,ix,~]=dtw(test{j},model{j});
        k=length(ix);
        score = score + exp(-1*(D/k));
    end
end
Score=score/T;
end

