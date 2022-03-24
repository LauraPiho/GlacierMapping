function [Q_wxyz, E, E1, VarXYZ, MagVarXYZ] = GetData(DataDown)


Q_wxyz(:,1) = (DataDown(:,11));
Q_wxyz(:,2) = (DataDown(:,12));
Q_wxyz(:,3) = (DataDown(:,13));
Q_wxyz(:,4) = (DataDown(:,14));

E(:,1) = deg2rad(DataDown(:,8));  
E(:,2) = deg2rad(DataDown(:,9));  
E(:,3) = deg2rad(DataDown(:,10)); 

E1 = quat2eul(DataDown(:,11:14),'ZYX');

VarXYZ(:,1:3) = (DataDown(:,18:20));

VarXYZ( : , 4) =  (DataDown( : , 21));
VarXYZ( : , 5) =  (DataDown( : , 22));
VarXYZ( : , 6) =  (DataDown( : , 23));

MagVarXYZ( : , 1) = (DataDown( : , 15));
MagVarXYZ( : , 2) = (DataDown( : , 16));
MagVarXYZ( : , 3) = (DataDown( : , 17));
