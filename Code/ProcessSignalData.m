function [VarXYZ, MagVarXYZ] = ProcessSignalData(VarXYZ,MagVarXYZ)


[itp , ~] = findchangepts([VarXYZ( : , 1 : 3) ]' ,...
        'MaxNumChanges' , 180 ,'Statistic','mean', 'MinDistance',20);
    
    itp(end + 1) = numel(VarXYZ( : , 1));
    
    count = 1;
    
    for p = 1 : numel(itp)
        
        for pp = 1 : 3
            
            if abs(mean(std(VarXYZ(count : itp(p) , pp)))) < 4
                q = 2;
            elseif abs(mean(std(VarXYZ(count : itp(p) , pp))))>= 4
                q = 1;
            end
        
     
            VarXYZ(count : itp(p) , pp) = sgolayfilt(VarXYZ(count : itp(p) , pp) , 1 , 11 );
            MagVarXYZ(count : itp(p) , pp) = sgolayfilt(MagVarXYZ(count : itp(p) , pp) , 1 , 11 );  

            VarXYZ(count : itp(p) , pp) = filloutliers(VarXYZ(count : itp(p) , pp) ...
                , 'center' , 'mean' , 'ThresholdFactor' , q);
            MagVarXYZ(count : itp(p) , pp) = filloutliers(MagVarXYZ(count : itp(p) , pp) ...
                , 'center' , 'mean' , 'ThresholdFactor' , q);       
        %             MagVarXYZ(count : itp(p) , pp) = sgolayfilt(MagVarXYZ(count : itp(p) , pp) , 1 , 31 );  

%                      

        end
        
        count = itp(p);
        
    end
    
    %
    
    count = 1;
    
    Temp1 = (VarXYZ(1 : end , 1 : 3));    
    for p = 2:numel(itp)
        
        Temp2 = VarXYZ(1:end,1:3);
        Temp2M = MagVarXYZ(1:end,1:3);
        
        temp = 0.5*(mean(Temp2(1:end,1:3)))+0.5*(mean(Temp1(count:itp(p-1),1:3),1));
        VarXYZ(count:itp(p-1),1:3) = detrend(Temp1(count:itp(p-1),1:3),10)  + temp;
       
        count = itp(p-1);
        
    end
    
    Temp2 = VarXYZ(1:end,1:3);   
    temp = 0.5*(mean(Temp2)) + 0.5*(mean(Temp1(count:itp(p),1:3),1));
    VarXYZ( count : itp(p) , 1 : 3) = detrend(Temp1(count:itp(p),1:3),10) + temp;
    
    