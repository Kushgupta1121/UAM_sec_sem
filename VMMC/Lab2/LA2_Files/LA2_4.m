%%task 4
%1.1.4 Exercise 4: Calculation of the relative position between cameras

unit=1;

%calculating the r1 matrix for the 1st camera, considering the 1st image.
R1=R{1};
[r1]=matrot_vmmc(R1,unit);

%calculating the r2 matrix for the 1st camera, considering the 1st image.
R2=R{2};
[r2]=matrot_vmmc(R2,unit);

%calculating the r3 matrix for the 1st camera, considering the 1st image.
R3=R{3};
[r3]=matrot_vmmc(R3,unit);


%calculating the position of second camera(C2) with respect to camera(C1),
%considering C1 as origin.
r_pos1=r2-r1;
t_pos1=T{2}-T{1};

%calculating the position of third camera(C3) with respect to camera(C1),
%considering C1 as origin.
r_pos2=r3-r1;
t_pos2=T{3}-T{1};