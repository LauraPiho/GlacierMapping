function [Q_wxyz, E, E1, VarXYZ, MagVarXYZ] = GetData(DataDown , i)


Q_wxyz(:,1) = (DataDown{i}(:,11));
Q_wxyz(:,2) = (DataDown{i}(:,12));
Q_wxyz(:,3) = (DataDown{i}(:,13));
Q_wxyz(:,4) = (DataDown{i}(:,14));

E(:,1) = deg2rad(DataDown{i}(:,8));  
E(:,2) = deg2rad(DataDown{i}(:,9));  
E(:,3) = deg2rad(DataDown{i}(:,10)); 

E1 = quat2eul(DataDown{i}(:,11:14),'ZYX');

VarXYZ(:,1:3) = (DataDown{i}(:,18:20));

VarXYZ( : , 4) =  (DataDown{i}( : , 21));
VarXYZ( : , 5) =  (DataDown{i}( : , 22));
VarXYZ( : , 6) =  (DataDown{i}( : , 23));

MagVarXYZ( : , 1) = (DataDown{i}( : , 15));
MagVarXYZ( : , 2) = (DataDown{i}( : , 16));
MagVarXYZ( : , 3) = (DataDown{i}( : , 17));
