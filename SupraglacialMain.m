%function [RotatedData] = InputDataNoGPS()
clear all
clc

load('SupraglacialData/SupraglacialData.mat')
[~,S] = size(SupraglacialDala);
% S = 1;

for i = 1:S
    
    DataDown{i} = table2array(SupraglacialData{i});
    % get data from the datafile
    [Q_wxyz, E, E1, VarXYZ, MagVarXYZ] = GetData(DataDown , i);
    
    % correct uncalibrated magnetometer data
    
    mag = MagVarXYZ( : , [1 , 2 , 3]);
    M1{i} = mag;
    [A , b] = magcal(mag);
    magx_correction = b(1);
    magy_correction = b(2);
    magz_correction = b(3);
    MagVarXYZ = [(mag( : , 1) - magx_correction) , (mag( : , 2) - magy_correction) , (mag( : , 3) - magz_correction)] * A;
    
    % Signal noise removal and processing
    
    [VarXYZ, MagVarXYZ] = ProcessSignalData1(VarXYZ,MagVarXYZ);
    
    % recalculate yaw angel
    
    q = ecompass(VarXYZ( : ,1:3),...
        MagVarXYZ( : ,1:3),'quaternion','ReferenceFrame','NED');
    e1 = euler( q , 'ZYX' ,'frame');
    e1(:,2:3) = E1(:,2:3);
    
    Q_wxyz = eul2quat(e1(:,[1,2,3]),'ZYX');
    Q_wxyz = quaternion(Q_wxyz);
    count1 = 0;

    % rotate the IMU signal
    RotatedData{i} = rotatepoint(Q_wxyz , VarXYZ( : , [ 1 , 2 , 3 ]));
    RotatedData{i}( : , 7 : 9) = rotatepoint(Q_wxyz , MagVarXYZ( : , [ 1 , 2 , 3 ])) ;
    RotatedData{i}( : , 4 : 6) = rotatepoint(Q_wxyz , VarXYZ( : , [ 4 , 5 , 6 ])) ;

    % post-process the rotated signal
    for j  = 1:9

        RotatedData1{i}( : , j) = smoothdata(RotatedData{i}( : , j) , 'movmean',100);

        RotatedData1{i}( : , j) = filloutliers(RotatedData1{i}( : , j) , 'center' , 'median' , 'ThresholdFactor' , 1);

    end
end
% Downsample for fatser processing

for i = 1:S
    
    Try{i} = downsample(RotatedData1{i}( : , : ) , 5);
    Try{i} = (Try{i}(:,:));
    
end



for i = 1:S
    for k = 1%:50
    EVA{1}{i}(:,k) = Try{i}(1 : end , 1);
    EVA{2}{i}(:,k) = Try{i}(1 : end , 2);
    EVA{3}{i}(:,k) = Try{i}(1 : end , 3);
    end
end

%
% The number of itterations can be changed 

% for dim = 1:2
%     
%     [Est_vel_all , M , State , stats] = iHMM_Gibbs_Velocity_min_feat_frame(Try(6) , dim , 2000);
%     EVA{dim} = Est_vel_all;
%     S_n{dim} = State;
%     M_All{dim} = M;
%     Stats{dim} = stats;
%     save('DataAll2020Summer.mat','EVA')
%     
% end

for i = 1:S
[XX, YY] = PathEstimationFromFeaturesSupraglacial(EVA, DataDown, i);
end
