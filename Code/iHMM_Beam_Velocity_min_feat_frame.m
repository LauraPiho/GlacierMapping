% %% Create a function that uses iHMM with Beam sampler to find velocity
%
% % Input in a cell matrix where each cell is a independent trial
% % MxN is a matrix, where M is the length of the trial and N is the number
% % of variables
%
% % Output, estimated velocity features

function [Est_vel_all , M , S_all , st] = iHMM_Beam_Velocity_min_feat_frame(RD_stretch2,dim , nr_itter )


[~,nr_trials] = size(RD_stretch2(:,:));

for i = 1:nr_trials
    Y = RD_stretch2{i}(:,[dim, dim+3, dim+6])'; 
    [~,m] = find(isnan(Y));
    Y(:,m) = [];
    Y1 = (RD_stretch2{i}(:,[dim]))';
    Y = zscore(Y')';
    
    T = size(Y,2);
    
    % Sample states using the iHmm Gibbs sampler.
    
    tic
    hypers.alpha0_a = 1;
    hypers.alpha0_b = 2;
    hypers.gamma_a = 1;
    hypers.gamma_b = 1;
    hypers.sigma2 = 2;
    hypers.mu_0 = 1;
    hypers.sigma2_0 = 2;
    
    % yt = ones(T,1);
    
    YH = ceil(rand(1,T) * 4);
    
    % YH(1:floor(T/2)) = YH(1:floor(T/2))*2;
    
    tic
    for h = 1
        
        [S, stats] = iHmmNormalSampleBeam(Y, hypers, nr_itter ,50 , 1 , YH);
    
    end
    toc
      
    st{i} = stats;
    figure
    
    clear Vel11 Time Time1 Vel1
    
    for g = 1:50
        
        for k = i %:23
            
            %RD2 = (Try1{k}(:,dim));
            %RD2 = Y';
            RD2 = (Y1(1,:))';
            
            path = S{g}.S;
            %path = movmean(path,20);
            %path = round(path);
            path = path';
            
            PP = path(1:end-1)-path(2:end);
            vert = find(PP~=0);
            [n,~] = size(vert);
            [n1,~] = size(PP);
            Sn(k ) = n;
            
            
            %Time = DataDown{k}(:,27);%.*1e-3;
            Time = linspace(0,1,n1);
            %Time = zscore(Time);
            Time = [Time(1),Time];
            count = 1;
            v0 = 0;
            %Vel1(count) = 0;
            jj=1;
            while jj <=n
                j = vert(jj);
                RD22 = [RD2(count:j,1)];
                [size_rd , ~] = size(RD22);
                
                while size_rd < 15
                    if jj > n-1, break, end
                    jj=jj+1;
                    j =vert(jj);
                    RD22 = [RD2(count:j,1)];
                    [size_rd , ~] = size(RD22);
                end
                RD22 = [RD22];
                [n3,~] = size(RD22);
                %
                
                Vel1_est = cumtrapz(([0;RD22]));
                
                Vel1(count:j+1) = (Vel1_est' );
                
                
                Vel2(count:j+1) = cumtrapz(Vel1(count:j+1)');
                v0 = Vel1(j);
                
                count = j ;
                jj = jj+1;
            end
            RD22 = (RD2(count:end,1));
            [n3,~] = size(RD22);
            Vel1(count:n1+1) = (cumtrapz((RD22)));
            Vel1(count:n1+1) = (Vel1(count:n1+1));
            %Vel1(count:n1+1) = Vel1(count:n1+1) - mean(Vel1(count:n1+1));
            Vel2(count:n1+1) = cumtrapz(Vel1(count:n1+1));
            hold on
            
            %s = n11*ones(n1,1);
            %Vel1 = movmean(Vel1,10);
            Vel1 = (Vel1);
            Vel2 = (Vel2);
            
            p1 = plot(Time(1:end),Vel1, 'r');
            p1.Color(4) = 0.1;
            Vel11(:,g) = Vel1;
            %Vel22(:,g) = Vel2;
            
            Est_vel_all{i} = Vel11;
            %Est_dis_all{i} = Vel22;
            
            
        end
        
    end
    %disp(path);
    M{i} = mean(Est_vel_all{i}');
    S_all{i} = S;
    %M2{i} = mean(Est_dis_all{i}');
    
end
close all
