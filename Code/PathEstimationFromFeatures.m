function [XX, YY] = PathEstimationFromFeatures(EVA, DataDown, i)

[~ , S] = size(EVA{1}{i});

for k = 1:S
        
        allp = [EVA{1}{i}(1:end, k) , EVA{2}{i}(1:end , k) , EVA{3}{i}(1:end , k)];
        New = (allp);
        
        X_norm( : , k) = (zscore(cumtrapz((New( : , 1)))));%,'movmedian',10);
        Y_norm( : , k) = (zscore(cumtrapz((New( : , 2)))));%,'movmedian',10);
        Z_norm( : , k) = (zscore(cumtrapz((New( : , 3)))));%,'movmedian',10);
        
end
    

[m, ~, ~, ~, ~] = wrldmagm(109 , 78.2232, 15.6267, decyear(2019,7,5),'2015');

a = [ 0 0 -9.82];
q = ecompass(a,m','quaternion','ReferenceFrame','ENU' );
[a,b,c,d] = parts(q);
q = [a,b,c,d];


    for k = 1:numel(X_norm(:,1))
        for j = 1:S
            N{j}(k,1:3) = rotateframe(quaternion(q),[X_norm(k,j),Y_norm(k,j),Z_norm(k,j)]);
        end
    end



lat0 = 78.2232;
long0 = 11.6267;
alt0 = 109;
wgs = wgs84Ellipsoid;

A1 = readtable('/media/laura/Backup Plus/Laura/Downloads06012021/Supraglacial2011_mapped.csv');
A1 = flip(table2array(A1(:,7:8)));

a1 = mean(A1(1:10,1));
a2 = mean(A1(end-10:end,1));

b1 = mean(A1(1:10,2));
b2 = mean(A1(end-10:end,2));

as = 120; 
ae = 140;

[Lat,Lon] = utm2deg(560593,8760428,'32 X');
[Lat1,Lon1] = utm2deg(560973,8760856,'32 X');

[X,Y,Z] = geodetic2ned(Lat1,...
Lon1,ae, lat0,long0,alt0,wgs);


x2 =  [X,Y,Z];

[X,Y,Z] = geodetic2ned(Lat,...
Lon,as, lat0,long0,alt0,wgs);

x1 = [X,Y,Z];


%figure

for j = 1:S
    
    NG{1} = N{j}(:,[1,2,3]);
    %NG{1}(:,2)=-NG{1}(:,2);
    [y1,y2] = start_end(NG);
    transform = zeros(3,2);
    
    for k = 1:3
        
        A = [y1(k) 1; y2(k) 1];
        b = [x1(k) ;x2(k)];
        transform(k,:) = A\b;
        
    end
    
    X_all(:,j) = (NG{1}(:,1).*transform(1,1)+transform(1,2));
    Y_all(:,j) = (NG{1}(:,2).*transform(2,1)+transform(2,2));
    Z_all(:,j) = (NG{1}(:,3).*transform(3,1)+transform(3,2));
    
end

figure
% for p = 1:S
%     hold on
%     %plot((Z_all{j}(:,p)))
%     [l , la , ~] = ned2geodetic((X_all(:,p)),(Y_all(:,p)),(Z_all(:,p)), lat0,long0,alt0,wgs);
%     [x,y,~] = deg2utm(l,la);
%     XXX(:,p) = x;
%     YYY(:,p) = y;
%     p1 = plot(x,y,'k');
%     p1.Color(4) = 0.1;
%     %hold on
%     
% end

erx = (std(X_all'))';
ery = (std(Y_all'))';
erz = (std(Z_all'))';
[l, la, h] = ned2geodetic(mean(X_all(:,:),2)+erx,mean(Y_all(:,:),2)+ery,mean(Z_all(:,:),2)+erz, lat0,long0,alt0,wgs);
[xu,yu,~] = deg2utm(l,la);


[l, la, h] = ned2geodetic(mean(X_all(:,:),2)-erx,mean(Y_all(:,:),2)-ery,mean(Z_all(:,:),2)-erz, lat0,long0,alt0,wgs);
[xl,yl,~] = deg2utm(l,la);

%figure

[l, la, h] = ned2geodetic(mean(X_all(:,:),2),mean(Y_all(:,:),2),mean(Z_all(:,:),2), lat0,long0,alt0,wgs);
[x,y,~] = deg2utm(l,la);
p1 = plot(x,y,'r');
%p1.Color(4) = 0.1;
XX = x;
YY = y;

scatter(x,y,5,smoothdata(detrend(downsample(DataDown(:,4),5),10),500))
colormap(jet)
%     clim = [min(Pressure),max(Pressure)];
%     scalingIntensity = 5;
%     myColors = jet;
%     [newMap, ticks, tickLabels] = MC_nonlinearCmap(myColors, 1012, clim, scalingIntensity,2);
%
%     colormap(newMap)
%
hold on

scatter(560593,8760428,40,'r','filled')
err = 4;
errorbar(560593,8760428,err,'both')

scatter(560973,8760856,40,'g','filled')
errorbar(560973,8760856,err,'both')

scatter(560978,8760738,40,'m','filled')
errorbar(560978,8760738,err,'both')

scatter(560856, 8760624,40,'k','filled')
errorbar(560856, 8760624,err,'both')

readtable('Englacial_UTM19082020_V2.txt');
A = table2array(ans);
A = table2array(ans);
XX1 = A(:,1);
YY1 = A(:,2);
p2 = plot(XX1,YY1,'r');

gpxread('Englacial_River.gpx');
hold on
GNSSLat = ans.Latitude;
GNSSLong = ans.Longitude;
[x,y,~] = deg2utm(GNSSLat,GNSSLong);
x = x(1:10);
y = y(1:10);
plot(x,y,'g')
end

