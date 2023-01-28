function Ppd = Ppendown(p)
tpd=0;
sump=0;
for i=1:numel(p)
    if p(i)~=0
    tpd=tpd+1;
    sump=sump+p(i);
    end
Ppd=sump/tpd;
end