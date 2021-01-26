%% function to get start and end point estimates
function [x1,x2] = start_end(Track) 

[~ , n] = size(Track);
xx=[]; yy=[]; zz=[];
xxe=[]; yye=[]; zze=[];
for i =1:n
    xx = [xx;Track{i}(1:140,1)];
    yy = [yy;Track{i}(1:140,2)];
    zz = [zz;Track{i}(1:140,3)];
    xxe = [xxe;Track{i}(end-140:end,1)];
    yye = [yye;Track{i}(end-140:end,2)];
    zze = [zze;Track{i}(end-140:end,3)];
end
x1(1) = mean(mean(xx));
x1(2) = mean(mean(yy));
x1(3) = mean(mean(zz));
x2(1) = mean(mean(xxe));
x2(2) = mean(mean(yye));
x2(3) = mean(mean(zze));