% Center of biorobotics, Tallinn
% Created January 2020, Edited August 2022
% Code by Laura Piho

clear all
clc
addpath('Code')
addpath('EnglacialData/')
addpath(genpath('IHMM'))
load('Data_Englacial.mat' )

D = [];

for i = 1

    [RotatedData1, DataDown] = Load_Data(EnglacialData,i);

    Try{1} = downsample(RotatedData1( : , : ) , 5);
    Try{1} = (Try{1}(1:end,:));

    for j = 1:50

        EVA{1}{i}(:,j) = Try{1}(1 : end , 1);
        EVA{2}{i}(:,j) = Try{1}(1 : end , 2);
        EVA{3}{i}(:,j) = Try{1}(1 : end , 3);

    end

    % The number of itterations can be changed
%     
    for dim = 1:2

        [Est_vel_all , M , State , stats] = iHMM_Beam_Velocity_min_feat_frame(Try , dim , 3000);
        EVA{dim}{i} = Est_vel_all{1};
        S_n{dim} = State;
        M_All{dim} = M;
        Stats{dim} = stats;

    end


    [XX, YY] = PathEstimationFromFeatures(EVA, DataDown, i);
    X1{i} = XX;
    Y1{i} = YY;
    
end