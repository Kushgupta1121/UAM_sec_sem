close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 4 (params)
BiosecurIDparameters_local={};
sign_genuine=[1,2,6,7];
%users_data={};  
for user=1:50
    sign=1;
    %sessions = {};
   sess_mat=[];  
    for sesion=1:4  
          %signs={};
          feat_mat = [];
          for sign_num=1:numel(sign_genuine)  
            
            if user<10 
                BiosecurID=load(['./DB/u100', num2str(user),'s000', num2str(sesion), '_sg000', num2str(sign_genuine(sign_num)), '.mat']);
            else
                BiosecurID=load(['./DB/u10', num2str(user),'s000', num2str(sesion), '_sg000', num2str(sign_genuine(sign_num)), '.mat']);
            end
            
            x=BiosecurID.x;
            y=BiosecurID.y;
            p=BiosecurID.p;
            % to store the user's signature's
            %sign_data=[x;y;p];
            %signs{sign_num}=sign_data;
           FeatVect = featureExtractor_local(x,y,p);
           feat_mat=[feat_mat;FeatVect];
           %BiosecurIDparameters(user,sign,:)=FeatVect;
           sign=sign+1;
          end
          %sessions{sesion} = signs;
          sess_mat=[sess_mat;feat_mat];
      end
  %users_data{user}=sessions;
    BiosecurIDparameters_local(user,:,:)=sess_mat;
end            

save('BiosecurIDparameters_local','BiosecurIDparameters_local');

%N=1 EER=30
%N=4 EER=29.5
%N=12 EER=27


%N=1 EER=6.93
%N=4 EER=5.33
%N=12 EER=6
%N=1                N=4                 N=12
%23.1374149659864	21.5000000000000	22.0816326530612
%4.26666666666667	2.88095238095238	2.32653061224490
