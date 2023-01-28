%function to compute path velocity magnitude 
function v= path_velocity_magnitude(dev_x_1,dev_y_1)
x=dev_x_1{1};
y=dev_y_1{1};
%path velocity magntiude
 v = sqrt(x + y);

end