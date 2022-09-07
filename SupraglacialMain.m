%function [RotatedData] = InputDataNoGPS()
clear all
clc

load('SupraglacialData/Data_Supraglacial.mat')


[~,S] = size(SupraglacialData);
S = 1;

for i = 1:S
    
    DataDown1{i} = (SupraglacialData{i});
    DataDown = (SupraglacialData{i});
    % get data from the datafile
    [Q_wxyz, E, E1, VarXYZ, MagVarXYZ] = GetData(DataDown);
    
    % deal with uncalibrated magnetometer data
    
    mag = MagVarXYZ( : , [1 , 2 , 3]);
    M1{i} = mag;
    [A , b] = magcal(mag);
    magx_correction = b(1);
    magy_correction = b(2);
    magz_correction = b(3);
    MagVarXYZ = [(mag( : , 1) - magx_correction) , (mag( : , 2) - magy_correction) , (mag( : , 3) - magz_correction)] * A;
    
    % Signal noise removal and processing
    V(i,:) = [std(VarXYZ),std(MagVarXYZ)];
    if V(i,2)<3.5;
        [VarXYZ, MagVarXYZ] = ProcessSignalData1(VarXYZ,MagVarXYZ, 600, 131);
    elseif V(i,2)>3.5 && V(i,2)<3.8;
        [VarXYZ, MagVarXYZ] = ProcessSignalData1(VarXYZ,MagVarXYZ, 500, 131);
    else V(i,2)>3.8;
        [VarXYZ, MagVarXYZ] = ProcessSignalData1(VarXYZ,MagVarXYZ, 400, 131);
    end
    % recalculate yaw angel
    
    q = ecompass(VarXYZ( : ,1:3),...
        MagVarXYZ( : ,1:3),'quaternion','ReferenceFrame','NED');
    e1 = euler( q , 'ZYX' ,'frame');
    % e1 = E1;
    e1(:,2:3) = E1(:,2:3);
    
    Q_wxyz = eul2quat(e1(:,[1,2,3]),'ZYX');
    Q_wxyz = quaternion(Q_wxyz);
    count1 = 0;
    
    % rotate the IMU signal
    RotatedData = rotatepoint(Q_wxyz , VarXYZ( : , [ 1 , 2 , 3 ]));
    RotatedData( : , 7 : 9) = rotatepoint(Q_wxyz , MagVarXYZ( : , [ 1 , 2 , 3 ])) ;
    RotatedData( : , 4 : 6) = rotatepoint(Q_wxyz , VarXYZ( : , [ 4 , 5 , 6 ])) ;


    % post-process the rotated signal
        V1(i,:) = [std(VarXYZ),std(MagVarXYZ)];

   if V(i,1) > 6
        q = 1;
    else
        q = 2;

    end
    
    for j  = 1:9

        RotatedData1{i}( : , j) = smoothdata(RotatedData( : , j) , 'movmean', 50);

        RotatedData1{i}( : , j) = filloutliers(RotatedData1{i}( : , j) , 'center' , 'median' , 'ThresholdFactor' , q);

    end
   
end

% Downsample for fatser processing

for i = 1:S
    
    Try{i} = downsample(RotatedData1{i}( : , : ) , 5);
    Try{i} = (Try{i}(:,:));
    
end


for i = 1:S
    for k = 1:50

    EVA{1}{i}(:,k) = Try{i}(1 : end , 1);
    EVA{2}{i}(:,k) = Try{i}(1 : end , 2);
    EVA{3}{i}(:,k) = Try{i}(1 : end , 3);

    end
end

%
% The number of itterations can be changed 
% % % % % % % 
for dim = 1:2

    [Est_vel_all , M , State , stats] = iHMM_Beam_Velocity_min_feat_frame(Try , dim , 2000);
    EVA{dim} = Est_vel_all;
    S_n{dim} = State;
    M_All{dim} = M;
    Stats{dim} = stats;

end

close all
for i = 1:S
[XX, YY] = PathEstimationFromFeaturesSupraglacial(EVA, DataDown1, i);
X{i} = XX;
Y{i} = YY;
P{i} = downsample(DataDown1{i}( : , [2,4,6] ) , 5);
end
