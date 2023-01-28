%function to extract angle
function pta= path_tangent_angle(dev_y_1,dev_x_1)

y=dev_y_1{1};
x=dev_x_1{1};
%Path-tangent angle
th=y./x;
pta = atan(th);
pta(isnan(pta))=0; % replacing NAN with 0.

end