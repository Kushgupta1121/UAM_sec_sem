function dev_x=derivative_x(x)
% function to calculate the first and second order derivative of X
x1=diff(x); % taking 1st derivative of x
x2=diff(x,2); % taking 2nd derivative of x
dev_x={x1;x2};

end