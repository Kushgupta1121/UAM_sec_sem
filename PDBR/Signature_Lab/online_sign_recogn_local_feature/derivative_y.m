function dev_y=derivative_y(y)
% function to calculate the first and second order derivative of Y
y1=diff(y); % taking 1st derivative of y
y2=diff(y,2); % taking 2nd derivative of y
dev_y={y1;y2};

end