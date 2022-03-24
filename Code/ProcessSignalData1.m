function [VarXYZ, MagVarXYZ] = ProcessSignalData1(VarXYZ,MagVarXYZ,mindist, sgl_factor)


[itp , ~] = findchangepts([VarXYZ( : , 1 : 2) ,MagVarXYZ( : , 1 : 3)  ]' ,...
        'MaxNumChanges' , 100 ,'Statistic','mean', 'MinDistance', mindist);
    
    itp(end + 1) = numel(VarXYZ( : , 1));
    
    count = 1;
    
    for p = 1 : numel(itp)
        
        for pp = 1 : 3
            
            if abs(mean(std(VarXYZ(count : itp(p) , pp)))) < 1.5
                q = 3;
            elseif abs(mean(std(VarXYZ(count : itp(p) , pp))))>= 1.5
                q = 2;
            end
%  
            VarXYZ(count : itp(p) , pp) = sgolayfilt(VarXYZ(count : itp(p) , pp) , 1 , sgl_factor );
            MagVarXYZ(count : itp(p) , pp) = sgolayfilt(MagVarXYZ(count : itp(p) , pp) , 1 , sgl_factor );  
            VarXYZ(count : itp(p) , pp) = filloutliers(VarXYZ(count : itp(p) , pp) ...
                , 'center' , 'median' , 'ThresholdFactor' , q);
            MagVarXYZ(count : itp(p) , pp) = filloutliers(MagVarXYZ(count : itp(p) , pp) ...
                , 'center' , 'median' , 'ThresholdFactor' , q);       
      
        end
        
        count = itp(p);
        
    end
    
    %
    
    count = 1;
    
    Temp1 = (VarXYZ(1 : end , 1 : 3));    
    Temp1M = (MagVarXYZ(1 : end , 1 : 3));    
    for p = 2:numel(itp)
        
        Temp2 = VarXYZ(1:end,1:3);
        Temp2M = MagVarXYZ(1:end,1:3);
        
        temp = 0.5*(mean(Temp2(1:end,1:3)))+0.5*(mean(Temp1(count:itp(p-1),1:3),1));
        VarXYZ(count:itp(p-1),1:3) = detrend(Temp1(count:itp(p-1),1:3),10)  + temp;
       
        
%         tempm = 0.5*(mean(Temp2M(1:end,1:3)))+0.5*(mean(Temp1M(count:itp(p-1),1:3),1));
%         MagVarXYZ(count:itp(p-1),1:3) = detrend(Temp1M(count:itp(p-1),1:3),10)  + tempm;
%         count = itp(p-1);
        
    end
    
    Temp2 = VarXYZ(1:end,1:3);   
    temp = 0.5*(mean(Temp2)) + 0.5*(mean(Temp1(count:itp(p),1:3),1));
    VarXYZ( count : itp(p) , 1 : 3) = detrend(Temp1(count:itp(p),1:3),10) + temp;
    
%     Temp2M = MagVarXYZ(1:end,1:3);   
%     tempm = 0.5*(mean(Temp2M)) + 0.5*(mean(Temp1M(count:itp(p),1:3),1));
%     MagVarXYZ( count : itp(p) , 1 : 3) = detrend(Temp1M(count:itp(p),1:3),10) + tempm;
    
    