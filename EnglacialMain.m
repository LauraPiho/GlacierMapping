% %function [RotatedData] = InputDataNoGPS()
clear all
clc
addpath('Code')
addpath('EnglacialData/')
addpath(genpath('IHMM'))
load('Data_Englacial.mat' )

i = 1;

[RotatedData1, DataDown] = Load_Data(EnglacialData,i);

Try{1} = downsample(RotatedData1( : , : ) , 5);
Try{1} = (Try{1}(1:end,:));


for j = 1:50
    EVA{1}{i}(:,j) = Try{1}(1 : end , 1);
    EVA{2}{i}(:,j) = Try{1}(1 : end , 2);
    EVA{3}{i}(:,j) = Try{1}(1 : end , 3);
end


% The number of itterations can be changed
% % 
for dim = 1:2
    
    [Est_vel_all , M , State , stats] = iHMM_Beam_Velocity_min_feat_frame(Try , dim , 5000);
    EVA{dim} = Est_vel_all;
    S_n{dim} = State;
    M_All{dim} = M;
    Stats{dim} = stats;

end

%

close all

[XX, YY] = PathEstimationFromFeatures(EVA, DataDown, i);
