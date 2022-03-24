% %function [RotatedData] = InputDataNoGPS()
clear all
clc
addpath('Code')
addpath('EnglacialData/')
addpath(genpath('IHMM'))
load('Data_Englacial.mat' )
% EnglacialData{4} = EnglacialData{4}(2500:end,:);
% % EnglacialData{1} = EnglacialData{1}(1:end-1800,:);
% % % EnglacialData{6} = EnglacialData{6}(1:51410,:);
% % EnglacialData{5} = EnglacialData{5}(1:end-4000,:);
% 
% EnglacialData{3} = EnglacialData{3}(1:end-5000,:);
% EnglacialData{2} = EnglacialData{2}(1000:end-10000,:);

% EnglacialData{6} = EnglacialData{6}(1:end-10000,:);
for i = 1:6
    
    [RotatedData1, DataDown] = Load_Data(EnglacialData,i);
    
    Try{1} = downsample(RotatedData1( : , : ) , 5);
    Try{1} = (Try{1}(1:end,:));
    
    for j = 1:50
        
        EVA{1}{i}(:,j) = Try{1}(1 : end , 1);
        EVA{2}{i}(:,j) = Try{1}(1 : end , 2);
        EVA{3}{i}(:,j) = Try{1}(1 : end , 3);
        
    end
    
    % The number of itterations can be changed
%     %
    for dim = 1:2
        
        [Est_vel_all , M , State , stats] = iHMM_Beam_Velocity_min_feat_frame(Try , dim , 2000);
        EVA{dim}{i} = Est_vel_all{1};
        S_n{dim} = State;
        M_All{dim} = M;
        Stats{dim} = stats;
        
    end
    
    
    
    [XX, YY] = PathEstimationFromFeatures(EVA, DataDown, i);
    X1{i} = XX;
    Y1{i} = YY;
end