function dev_p=derivative_p(p)
% function to calculate the first and second order derivative of P

p1=diff(p); % taking 1st derivative of p
p2=diff(p,2); % taking 2nd derivative of p
dev_p={p1;p2};

end