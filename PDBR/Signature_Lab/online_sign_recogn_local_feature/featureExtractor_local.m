function FeatVect = featureExtractor_local(x,y,p)

%Local features

dev_x=derivative_x(x);
dev_y=derivative_y(y);
dev_p=derivative_p(p);

% First order Derivative
dev_x_1=dev_x(1);
dev_p_1=dev_p(1);
dev_y_1=dev_y(1);

% Second order derivative
dev_y_2=dev_y(2);
dev_x_2=dev_x(2);
dev_p_2=dev_p(2);

%Path-tangent
pta = path_tangent_angle(dev_y_1,dev_x_1);

%Path velocity magnitude
v= path_velocity_magnitude(dev_x_1,dev_y_1);

%Feature Vector
%FeatVect=[dev_x_1,dev_x_2,dev_y_1,dev_y_2,dev_p_1,dev_p_2];

FeatVect=[dev_x_1,dev_x_2,dev_y_1,dev_y_2,dev_p_1,dev_p_2,v,pta];

end
