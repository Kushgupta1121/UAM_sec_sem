function [points,decomposition] =  myDetector(gima,params)
    %% get detections:
    addpath('non-linear scale-space');

    switch params.detector
        case 'DoH'
              SS                  =   doScaleSpaceGivenSigmas(gima,params.sigmas);
              DoH = extractDeterminantOfHessianGivenSigmas(SS,params.sigmas);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(DoH,1,0,params.npoints,params.npoints);
               points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = SS;
        
        % Linear Scale space Detectors.
         
        case 'LoG_ss'

              SS                  =   doScaleSpaceGivenSigmas(gima,params.sigmas);
              LoG                 = extractLaplacianGivenSigmas(SS,params.sigmas);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(LoG,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = SS;
        case 'DoG_ss' 

              SS                  =   doScaleSpaceGivenSigmas(gima,params.sigmas);
              DoG                 = extractDoGGivenSigmas(SS,params.sigmas,params.noctaves,params.nscales);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(DoG,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = SS;  

         case 'K_ss'  

              SS                  =   doScaleSpaceGivenSigmas(gima,params.sigmas);
              kdet                 = extractkGivenSigmas(SS,params.sigmas);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(kdet,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = SS; 

        % Non-Linear Scale space.
         case 'LoG_ss_NL'

              NLSS                  =   doNonLinearScaleSpaceGivenSigmas(gima,params.sigmas,0.7,3);
              LoG                 = extractLaplacianGivenSigmas(NLSS,params.sigmas);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(LoG,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = NLSS;
        case 'DoG_ss_NL'  

              NLSS                  =   doNonLinearScaleSpaceGivenSigmas(gima,params.sigmas,0.7,3);
              DoG                 = extractDoGGivenSigmas(NLSS,params.sigmas,params.noctaves,params.nscales);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(DoG,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = NLSS;  

         case 'K_ss_NL'  

              NLSS                  =   doNonLinearScaleSpaceGivenSigmas(gima,params.sigmas,0.7,3);
              kdet                 = extractkGivenSigmas(NLSS,params.sigmas);
              [M,MaxPos,m,MinPos] = MinimaMaxima3D(kdet,1,0,params.npoints,params.npoints);

    
              points.Metric          = abs(m);
              points.Location        = [MinPos(:,2),MinPos(:,1)];
              points.SignOfLaplacian = -1;

              points.sid             = MinPos(:,3);

              points.Metric          = [points.Metric;M];
              points.Location        = [points.Location;[MaxPos(:,2),MaxPos(:,1)]];
              points.SignOfLaplacian = 1;
              points.sid             = [points.sid;MaxPos(:,3)];
              
              points.Scale           = params.sigmas(points.sid);
              
              decomposition          = NLSS; 

              
         case 'SURF'
             
             points                 =  detectSURFFeatures(gima);
             
             decomposition{1}       = gima;
             
        case 'SIFT'
             % see additional detection methods and options provided by vlfeat in help vl_covdet
              [frame]= ...
              vl_sift(single(gima),'Octaves',params.noctaves,'Levels',params.nscales,'PeakThresh', params.th); 
            % parse to common structure
               points.Location        = [frame(1,:)',frame(2,:)'];
               points.Scale           =  frame(3,:)';
               points.Orientation     =  frame(4,:)';
               points.Metric          =   0.5.*ones(size( frame(4,:)'));% unknown
               points.SignOfLaplacian =        zeros(size(frame(4,:)'));% unknown
               
               decomposition{1}       = gima;    
        
        case 'KAZE'
             
             points                 =  detectKAZEFeatures(gima);
             
             decomposition{1}       = gima;
         
        case 'anyother'
               ...

        otherwise  % SURF

              points                 =  detectSURFFeatures(gima);
             
              decomposition{1}       = gima;

    end
end