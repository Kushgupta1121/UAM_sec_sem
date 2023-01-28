function Score=Matcher(test,Model)
%Score= sqrt((model(1)-test(1)^2+model(2)-test(2)^2+model(3)-test(3)^2+model(4)-test(4)^2));

if size(Model,1)==1
    Score=pdist2(Model,test,'euclidean');

elseif size(Model,1)==4
    
    Score=pdist2(Model,test,'euclidean');
    Score=mean(Score,'all');

else 
    Score=pdist2(Model,test,'euclidean');
    Score=mean(Score,'all');

end

end