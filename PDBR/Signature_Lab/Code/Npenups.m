function Npu = Npenups(p)
Npu=0;
for i=1:numel(p)
    if p(i)==0 && p(i-1)~=0
        Npu=Npu+1;
    end
end