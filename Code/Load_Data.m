function [RotatedData1, DataDown] = Load_Data(Englacial_data,i)

% get data from the datafile
DataDown = table2array(Englacial_data{i});
[Q_wxyz, E, E1, VarXYZ, MagVarXYZ] = GetData(DataDown);

% correct uncalibrated magnetometer data

mag = MagVarXYZ( : , [1 , 2 , 3]);
M1{i} = mag;
[A , b] = magcal(mag);
magx_correction = b(1);
magy_correction = b(2);
magz_correction = b(3);
MagVarXYZ = [(mag( : , 1) - magx_correction) , (mag( : , 2) - magy_correction) , (mag( : , 3) - magz_correction)] * A;

% Signal noise removal and processing

[VarXYZ, MagVarXYZ] = ProcessSignalData(VarXYZ,MagVarXYZ);

% recalculate yaw angel

q = ecompass(VarXYZ( : ,1:3),...
    MagVarXYZ( : ,1:3),'quaternion','ReferenceFrame','NED');
% fuse = imufilter('SampleRate' , 100 , 'ReferenceFrame' , 'NED'); % , 'HasMagnetometer' , false) ;
% q = fuse(VarXYZ(:,1:3),VarXYZ(:,4:6));

e1 = euler( q , 'ZYX' ,'frame');
e1(:,2:3) = E1(:,2:3);

Q_wxyz = eul2quat(e1(:,[1,2,3]),'ZYX');
Q_wxyz = quaternion(Q_wxyz);
count1 = 0;

% rotate the IMU signal

RotatedData = rotatepoint(Q_wxyz , VarXYZ( : , [ 1 , 2 , 3 ]));%-((rotatepoint((Q_wxyz{i}),(VarXYZ{i}(:,1:3)))));
RotatedData( : , 7 : 9) = rotatepoint(Q_wxyz , MagVarXYZ( : , [ 1 , 2 , 3 ])) ;
RotatedData( : , 4 : 6) = rotatepoint(Q_wxyz , VarXYZ( : , [ 4 , 5 , 6 ])) ;

% post-process the rotated signal

for j  = 1:9
    
    RotatedData1( : , j) = filloutliers(RotatedData( : , j) , 'nearest' , 'median' , 'ThresholdFactor' , 3);
    RotatedData1( : , j) = smoothdata(RotatedData1( : , j) , 'movmean', 30);
    
end
end