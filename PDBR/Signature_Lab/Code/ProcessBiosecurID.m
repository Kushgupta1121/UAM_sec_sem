close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 4 (params)
BiosecurIDparameters=ones(50,16,4);
%sign=0;
sign_genuine=[1,2,6,7];
users_data={};  
for user=1:50
    sessions = {};
    sess_mat=[];  
    for sesion=1:4  
          signs={};
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
            sign_data=[x;y;p];
            signs{sign_num}=sign_data;
            FeatVect = featureExtractor(x,y,p);
           feat_mat=[feat_mat;FeatVect];
          end
          sessions{sesion} = signs;
          sess_mat=[sess_mat;feat_mat];
      end
  users_data{user}=sessions;
  BiosecurIDparameters(user,:,:)=sess_mat;   
end            

save('BiosecurIDparameters','BiosecurIDparameters');
%% To display the 1st signature of 1st user taken in 1st session, to see
% other user's signature change the user, session or sign_number

to_plot=1; % change the value to to_plot to see the user's signature
if to_plot==1
user= 2;
sesion = 3;
sign_number =4;
data=users_data{user}{sesion}{sign_number};
x=data(1,:);
y=data(2,:);
p=data(3,:);
t=linspace(0,length(x),length(x));

         figure(1)
          plot(x,y);
          title("User's Signature");
          xlabel('x');ylabel('y');
          
          figure(2)
          
          plot(t,x);
          title("X as a function of t");
          xlabel('t');ylabel('X');
          
          figure(3)
          plot(t,y);
          title("Y as a function of t");
          xlabel('t');ylabel('Y');

          figure(4)
          plot(t,p);
          title("P as a function of t");
          xlabel('t');ylabel('P');
end

%% The histogram's
to_hist=0; % to see the Histogram's change the value to 1
if to_hist==1
figure(1)
histogram(BiosecurIDparameters(:,:,1),'Normalization','probability');
title('Total duration');

figure(2)
histogram(BiosecurIDparameters(:,:,2),'Normalization','probability');
title('N pen-ups');

figure(3)
histogram(BiosecurIDparameters(:,:,3),'Normalization','probability');
title('Tpendown/T');

figure(4)
histogram(BiosecurIDparameters(:,:,4),'Normalization','probability');
title('Average P in pen-down');
end

%N=1 EER=30
%N=4 EER=29.5
%N=12 EER=27

