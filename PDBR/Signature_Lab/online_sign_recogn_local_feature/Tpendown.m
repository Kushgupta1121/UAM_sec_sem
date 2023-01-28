function Tpd = Tpendown(p)
pd=0;
T= length(p);
for i = 1: numel(p)
if p(i)~= 0
    pd=pd+1;
end
%pd=pd/200;
Tpd=pd/T;
end