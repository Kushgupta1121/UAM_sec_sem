function [P_euc,Q_euc] =euclidean_reconstruction(q_data,P_cams,ncam,Q_2cam_est)

P_est=P_cams;
Q_est=Q_2cam_est;
q=q_data;
% ------------------------------------------------------------------------
% Compute the affine reconstrucion based on vanishing points (projections of points at infinity on your images)
% ------------------------------------------------------------------------
% Compute the projection of the 3 vanishing points in each image. Use cross() (cross-vector product)
% The 8 first points in q_data are the positions of the cube vertices. 
% Calculate crossing points of parallel lines (in space) from the vertices of that cube 
% Creating lines for the cubes
l12=cross(q_data(:,1,:),q_data(:,2,:));l34=cross(q_data(:,4,:),q_data(:,3,:));
p1=cross(l12,l34);

l14=cross(q_data(:,1,:),q_data(:,4,:));l23=cross(q_data(:,2,:),q_data(:,3,:));
p2=cross(l14,l23);

l26=cross(q_data(:,2,:),q_data(:,6,:)); l37= cross(q_data(:,3,:),q_data(:,7,:));
p3=cross(l26,l37);

%Unhomogenizing coordiantes
p1=un_homogenize_coords(p1);
p2=un_homogenize_coords(p2);
p3=un_homogenize_coords(p3);


% It is useful to check that the computed vanishing points are correct. You
% can use the draw_lines() for that purpose
for k=1:ncam
    figure();
    title('Cube');
    hold on
    scatter(q(1,:,k),q(2,:,k),30,[1,0,0]);
    
    draw_proj_cube(q(:,:,k));
    % draw the projection of lines and vanishing points in each image
    hold on
    scatter(p1(1,:,k),p1(2,:,k),30,[1,0,0]);

    hold on
    scatter(p2(1,:,k),p2(2,:,k),30,[1,0,0]);

    hold on
    scatter(p3(1,:,k),p3(2,:,k),30,[1,0,0]);
    
    draw_lines(l12(:,:,k));
    draw_lines(l34(:,:,k));
    draw_lines(l14(:,:,k));
    draw_lines(l23(:,:,k));
    draw_lines(l26(:,:,k));
    draw_lines(l37(:,:,k));
   

end

% Build a (3,3,ncam) matrix with the position (hom. coords) of the vanishing points in each image
% ...
vanish_point=[p1,p2,p3];
% Obtain the 3D points at the infinity plane by linear triangulation. Use
% the linear_triangulation() function

X=linear_triangulation(vanish_point,P_est);

% The following function returns the hom coords. of a plane if X(3,4) contains 3 points of that plane 
plane = NumKernel(X.'); 

% Build the P3 transformation H_aff that transforms the projective reconstruction into a affine reconstruction
H_aff=[ eye(3) zeros(3,1);plane'];

% Apply H_aff to points and projection cameras
Qa = H_aff * Q_est ; 
Xa = H_aff * X ;  %

Pa=zeros(3, 4, ncam);
for i =1:ncam
Pa(:, :, i) = P_est(:, :, i)*inv(H_aff);
%Pa(:, :, 2) = P_est(:, :, 2)*inv(H_aff);
end
% ------------------------------------------------------------------------
% % Visualize affine reconstruction. Use draw_3Dcube() 
% ------------------------------------------------------------------------
draw_3Dcube(Qa);

% ------------------------------------------------------------------------
% Compute the Euclidean reconstruction, knowing that we have a cubic
% scene
% ------------------------------------------------------------------------
% Use calc_reference_homography(Q): Computes the space homography Heuc that transforms the canonical reference 
% (1 0 0 0) (0 1 0 0) (0 0 1 0) (0 0 0 1) (1 1 1 1) into the 5 3D points that are stored in Q 

Qq=[Xa Qa(:,1) Qa(:,7)];
Heuc = inv(calc_reference_homography(Qq));

% Apply that transformation to the projective or affine points and
% matrices. Depending on which you used to obtain the transformation
 Q_euc = Heuc * Qa;
 for i= 1:ncam
 P_euc(:,:,i) = Pa(:,:,i) * inv(Heuc);
 %P_euc(:,:,2) = Pa(:,:,2) * inv(Heuc);
 end
end