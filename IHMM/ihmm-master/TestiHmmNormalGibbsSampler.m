% Test the iHMM Gibbs sampler with normal output.
%T = 500;                        % Length of HMM
K = 5;                          % Number of states
figure

for i = 1:4%:6%:6%:2 %:3 %1:3%:numel(DataTry)
    Y = newData(i,:);
    %Y = RD{i}';
    
    [~,m] = find(isnan(Y));
    Y(:,m) = [];
    Y = movmad(Y,10);
    Y = zscore(Y);
    T = size(Y,2);
    % stream = RandStrem('mt19937ar','seed',21);
    % RandStream.setDefaultStream(stream);
    
    % Parameters for HMM which generates data.
    A = [ 0.0 0.5 0.5 0.0;
        0.0 0.0 0.5 0.5;
        0.5 0.0 0.0 0.5;
        0.5 0.5 0.0 0.0 ];
    E.mu = [-3.0; 1.0; -2.0; 2.0];
    E.sigma2 = [0.5; 0.5; 0.5; 0.5];
    pi = [1.0; zeros(K-1,1)];
    
    % Generate data.
    %[Y, STrue] = HmmGenerateData(1, T, pi, A, E, 'normal');
    
    % Sample states using the iHmm Gibbs sampler.
    tic
    hypers.alpha0_a = 4;
    hypers.alpha0_b = 1;
    hypers.gamma_a = 3;
    hypers.gamma_b = 6;
    hypers.sigma2 = 1.5;
    hypers.mu_0 = 0.0;
    hypers.sigma2_0 = 1.0;
tic
for h = 1
    [S, stats] = iHmmNormalSampleGibbs(Y, hypers,500, 50, 5, ceil(rand(1,T) * 5));
    %S1(h,:) = S;
end
toc
% 
% figure(1)
% subplot(3,2,1)
% plot(stats.K)
% title('K')
% subplot(3,2,2)
% plot(stats.jll)
% title('Joint Log Likelihood')
% subplot(3,2,3)
% plot(stats.alpha0)
% title('alpha0')
% subplot(3,2,4)
% plot(stats.gamma)
% title('gamma')
% subplot(3,2,5)
% imagesc(SampleTransitionMatrix(S{1}.S, zeros(1,S{1}.K))); colormap('Gray');
% title('Transition Matrix')

figure
clear Vel11 Time Time1 Vel1
for g = 1:50
    
    
    for k = i%:23
        
        %RD2 = (DataTry{k}(:,1));
        RD2 = Y';
        %RD2 = movmean(Vel11(:,g),5);
        %RD2 = zscore(RD2);
        %RD2 = detrend(RD2);
        %     wname = 'sym4';
        %     level = 5;
        %     sorh  = 's'; % type of thresholding
        %     thr = 3.5;
        %RD2 = wdenoise(RD2)';
        
        %     [RD2,cxd,lxd,perf0,perfl2] = wdencmp('gbl',RD2,wname,level,thr,sorh,1);
        
        %k=2;
        path = S{g}.S;
        path = path';
        %path = P{k};
        %path = movmean(path,5);
        %path = round(path);
        PP = path(1:end-1)-path(2:end);
        vert = find(PP~=0);
        [n,~] = size(vert);
        [n1,~] = size(PP);
        Sn(k ) = n ;
        
        
        %Time = DataDown{k}(:,27);%.*1e-3;
        Time = linspace(0,1,n1);
        %Time = zscore(Time);
        Time = [Time(1),Time];
        count = 1;
        Vel1(count) = 1;
        for j = 1:n
            %RD22 = RD2;
            j =vert(j);
            RD22 = [0;RD2(count:j,1)];
            
            JJ = j-count+2;
            Time1 =Time(count:j+1);
            %Time = Time1(count:j+1);
            Vel1_est = cumtrapz(Time1, RD22);
            Vel1(count:j) = (Vel1_est(2:end));
            %Vel1(count:j) = Vel1_est(2:end) - mean(Vel1_est(2:end));
            
            %Vel2(count:j) = cumtrapz(Vel1(count:j));
            count = j ;
        end
        JJ = n1+2-count;
        Time1 = Time(count:n1+1);
        Vel1(count:n1+1) = (cumtrapz(Time1,RD2(count:n1+1,1)));
        Vel1(count:n1+1) = (Vel1(count:n1+1));
        %Vel1(count:n1+1) = Vel1(count:n1+1) - mean(Vel1(count:n1+1));
        %Vel2(count:n1+1) = cumtrapz(Vel1(count:n1+1));
        hold on
        
        [n1, ~] = size(path);
        
        %s = n11*ones(n1,1);
        Vel1 = movmean(Vel1,10);
        %Vel1 = zscore(Vel1);
        p1 = plot(Time(1:end),zscore(detrend(Vel1)), 'r');
        p1.Color(4) = 0.1;
        Vel11(:,g) = Vel1;
        VCV{i} = Vel11;
        % scatter(s,-(1:1:n1),s,Vel1(1:n1))
        %n11 = n11+0.01;
        %scatter((1:1:n1),DataNew{k}(1:n1), s, Vel1(1:n1))
        
    end
    
end
hold on
plot(linspace(0,1,391),zscore(detrend(X(1195:end,1))));
end