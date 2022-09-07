function [x1, y1] = PathEstimationFromFeaturesSupraglacial(EVA, DataDown, i)

load('GNSS_Drifter02072019.mat')

[~ , S] = size(EVA{1}{i});

for k = 1:S
    
    allp = [EVA{1}{i}(1:end, k) , EVA{2}{i}(1:end , k) , EVA{3}{i}(1:end , k)];
    New = (allp);
    
    X_norm( : , k) = (zscore(cumtrapz((New( : , 1)))));%,'movmedian',10);
    Y_norm( : , k) = (zscore(cumtrapz((New( : , 2)))));%,'movmedian',10);
    Z_norm( : , k) = (zscore(cumtrapz((New( : , 3)))));%,'movmedian',10);
    
end


[m, ~, ~, ~, ~] = wrldmagm(109 , 78.2232, 15.6267, decyear(2019,7,5),'2015');

a = [ 0 0 9.82];
q = ecompass(a,m','quaternion','ReferenceFrame','ENU' );
[a,b,c,d] = parts(q);
q = [a,b,c,d];


for k = 1:numel(X_norm(:,1))
    for j = 1:S
        N{j}(k,1:3) = rotateframe(quaternion(q),[X_norm(k,j),Y_norm(k,j),Z_norm(k,j)]);
    end
end
%figure

% for j = 1:S
%     NG{1} = N{j}(:,[1,2,3]);
%     [transform]=FindLineanTransform(CartCoordinates,NG);
%     %         for i =1:3
%     %             subplot(3,1,i)
%     %             hold on
%     %             plot((NG{1}(:,i).*transform(i,1)+transform(i,2)))
%     %             % Estimated{j}(:,i) = ((NG{1}(:,i).*transform(i,1)+transform(i,2)));
%     %         end
%     X_all(:,j) = (NG{1}(:,1).*transform(1,1)+transform(1,2));
%     Y_all(:,j) = (NG{1}(:,2).*transform(2,1)+transform(2,2));
%     Z_all(:,j) = (NG{1}(:,3).*transform(3,1)+transform(3,2));
% end


lat0 = 78.2232;
long0 = 11.6267;
alt0 = 109;

wgs = wgs84Ellipsoid;
% 
%  A1 = readtable('Supraglacial2011_mapped.csv');
%  A1 = flip(table2array(A1(:,7:8)));
A = load('Average_UTM.mat');

A1(:,1) = A.X1(:,1);
A1(:,2) = A.X1(:,2);

a1 = mean(A1(1:10,1));
a2 = mean(A1(end-10:end,1));

b1 = mean(A1(1:10,2));
b2 = mean(A1(end-10:end,2));

as = 120; %max(table2array(Data{1}(:,8)));
ae = 140;
%
[Lat,Lon] = utm2deg(a1,b1,'32 X');
[Lat1,Lon1] = utm2deg(a2,b2,'32 X');


[X,Y,Z] = geodetic2enu(Lat1,...
    Lon1,ae, lat0,long0,alt0,wgs);

x2 =  [X,Y,Z];

[X,Y,Z] = geodetic2enu(Lat,...
    Lon,as, lat0,long0,alt0,wgs);

x1 = [X,Y,Z];


% clear NG X_all Y_all Z_all

Pressure1 = downsample(mean(DataDown{1}(:,[2,4,6]),2),5);
Pressure1 = Pressure1(2200:end-800);

    for j = 1:S
        
        NG{1} = N{j}([1:end],[1,2,3]);
        %NG{1}(:,2)=-NG{1}(:,2);
        [y1,y2] = start_end(NG);
        transform = zeros(3,2);
        
        for i = 1:3
            A = [y1(i) 1;y2(i) 1];
            b = [x1(i) ;x2(i)];
            transform(i,:) = A\b;
        end
        
%         for i =1:3
%             subplot(3,1,i)
%             hold on
%             plot((NG{1}(:,i).*transform(i,1)+transform(i,2)));
%             % Estimated{j}(:,i) = ((NG{1}(:,i).*transform(i,1)+transform(i,2)));
%         end
        
        X_all(:,j) = (NG{1}(:,1).*transform(1,1)+transform(1,2));
        Y_all(:,j) = (NG{1}(:,2).*transform(2,1)+transform(2,2));
        Z_all(:,j) = (NG{1}(:,3).*transform(3,1)+transform(3,2));
        
    end


erx = (std(X_all'))';
ery = (std(Y_all'))';
erz = (std(Z_all'))';

[l, la, h] = enu2geodetic(mean(X_all(:,:),2)+erx,mean(Y_all(:,:),2)+ery,mean(Z_all(:,:),2)+erz, lat0,long0,alt0,wgs);
[xu,yu,~] = deg2utm(l,la);


[l, la, h] = enu2geodetic(mean(X_all(:,:),2)-erx,mean(Y_all(:,:),2)-ery,mean(Z_all(:,:),2)-erz, lat0,long0,alt0,wgs);
[xl,yl,~] = deg2utm(l,la);

figure

[l, la, h] = enu2geodetic(mean(X_all(:,:),2),mean(Y_all(:,:),2),mean(Z_all(:,:),2), lat0,long0,alt0,wgs);
[x1,y1,~] = deg2utm(l,la);
X_utm = x1;
Y_utm = y1;

p1 = plot(x1,y1,'r');
%p1.Color(4) = 0.1;

f0 = fill([xl;flipud(xu)],[yu;flipud(yl)],[1 .7 .8],'linestyle','none');
alpha(f0,0.5)
clim = [min(Pressure1),max(Pressure1)];
scalingIntensity = 5;
myColors = jet;

%[newMap, ticks, tickLabels] = MC_nonlinearCmap(myColors, 1001, clim, scalingIntensity,2);
%     [l, la, h] = enu2geodetic(mean(X_all{j}(:,:),2),mean(Y_all{j}(:,:),2),mean(Z_all{j}(:,:),2), lat0,long0,alt0,wgs);
%     [x,y,~] = deg2utm(l,la);
%     p1 = plot(x,y,'r');
%p1.Color(4) = 0.1;
%
%     hold on
%     scatter(560593,8760428,40,'b','filled')
%     err = 4;
%     errorbar(560593,8760428,err,'both')
%
%     scatter(560973,8760856,40,'r','filled')
%     errorbar(560973,8760856,err,'both')
%
%     scatter(560978,8760738,40,'g','filled')
%     errorbar(560978,8760738,err,'both')
%
%     scatter(560856, 8760624,40,'m','filled')
%     errorbar(560856, 8760624,err,'both')
hold on
err = 4;
%   f1 = fill([A1(:,1);flipud(A1(:,1)+err)],[A1(:,2);flipud(A1(:,2)+err)],[.2 .2 .2],'linestyle','none');
%   f2 = fill([A1(:,1);flipud(A1(:,1)-err)],[A1(:,2);flipud(A1(:,2)-err)],[.2 .2 .2],'linestyle','none');
%   alpha(f1,0.5)
%   alpha(f2,0.5)
plot(A1(:,1),A1(:,2),'k')
p1 = plot(x1,y1,'r');
%scatter(x,y,10,Pressure1)




%
% for i = 1:11
% P{i} = (mean((DataDown{i}(:,[2,4,6])),2));
% end
%
% P{4} = P{4}(1300:end);
% P{7} = P{7}(2600:end);
%
%
% for i = 1:11
% P{i} = downsample(P{i},4);
% end
%
% clear B_u
% count = 1;
% for i =1 : 11
% B_u{count} = [Y_utm{i}, X_utm{i}, P{i}];
% count = count +1;
% end
% [average_X, stdS, pathM] = DBA(B_u);
%
%
% XX = A1(:,1);
% YY = A1(:,2);
%
% for i = 1
%     temp_x = mean(average_X(:,2),2);
%     temp_y = mean(average_X(:,1),2);
%     Idx = knnsearch(XX,temp_x,'K',10);
%     Idy = knnsearch(YY,temp_y,'K',10);
%
%     for j = 1:numel(temp_x)
%         RMSE_x{i}(j) = sqrt(mean((temp_x(j) - XX(Idx(j,:))).^2));  % Root Mean Squared Error
%         RMSE_y{i}(j) = sqrt(mean((temp_y(j) - YY(Idy(j,:))).^2));  % Root Mean Squared Error
%
%         Err_x{i}(j) = abs(mean((temp_x(j) - XX(Idx(j,:)))));  % Root Mean Squared Error
%         Err_y{i}(j) = abs(mean((temp_y(j) - YY(Idy(j,:)))));  % Root Mean Squared Error
%
%     end
% end
%
% figure
% hold on
% err = 4;
% f1 = fill([A1(:,1);flipud(A1(:,1)+err)],[A1(:,2);flipud(A1(:,2)+err)],[.7 .8 1],'linestyle','none');
% f2 = fill([A1(:,1);flipud(A1(:,1)-err)],[A1(:,2);flipud(A1(:,2)-err)],[.7 .8 1],'linestyle','none');
% alpha(f1,0.5)
% alpha(f2,0.5)
%
% errx = stdS(:,2);
% erry = stdS(:,1);
%
% f3 = fill([average_X(:,2);flipud(average_X(:,2)+errx)],[average_X(:,1);flipud(average_X(:,1)+erry)],[1 .7 .8],'linestyle','none');
% f4 = fill([average_X(:,2);flipud(average_X(:,2)-errx)],[average_X(:,1);flipud(average_X(:,1)-erry)],[1 .7 .8],'linestyle','none');
% alpha(f3,0.5)
% alpha(f4,0.5)
% plot(A1(:,1),A1(:,2),'b')
% plot(average_X(:,2),average_X(:,1),'r')
%
