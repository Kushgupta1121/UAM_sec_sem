%% 1.1.2: Exercise 2: Computation of the internal and external parameters
%clc;
%clear all;
%close all;
% =========== Calculating the Iternal Parameters of the Camera ============
%%passing the Modified Homography matrix to calculate A parameter for 3,4,5 Homograpies

% Passing the first  Homographies to internal parameters solve VMMC function
A_3 = internal_parameters_solve_vmmc({H_out{1:3}});

% Passing the first 4 Homographies to internal parameters solve VMMC function
A_4 = internal_parameters_solve_vmmc({H_out{1:4}});

% Passing the first 3 Homographies to internal parameters solve VMMC function
A_5 = internal_parameters_solve_vmmc(H_out);

%%passing the Original Homography matrix to calculate A parameter for 3,4,5 Homograpies

% Passing the first  Homographies to internal parameters solve VMMC function
A_3_orign = internal_parameters_solve_vmmc({H{1:3}});

% Passing the first 4 Homographies to internal parameters solve VMMC function
A_4_origin = internal_parameters_solve_vmmc({H{1:4}});

% Passing the first 3 Homographies to internal parameters solve VMMC function
A_5_origin = internal_parameters_solve_vmmc(H);


%% ============ Calculating the External Parameters of the Camera ============
% External Parameters for all the 5 Orientations and respective Homograpies
[R T] = external_parameters_solve_vmmc(A_5, H_out);
