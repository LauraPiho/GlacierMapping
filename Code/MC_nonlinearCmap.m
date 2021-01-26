% This code is by Allen Yin on 2 Nov 2017 on 
% https://se.mathworks.com/matlabcentral/answers/307318-does-matlab-have-a-nonlinear-colormap-how-do-i-make-one 
% The code produces nonlinear colormap and has been used to create a more clear map of pressure distribution.
function [newMap, ticks, tickLabels] = MC_nonlinearCmap(myColors, centerPoint, cLim, scalingIntensity, inc)
    dataMax = cLim(2);
    dataMin = cLim(1);
    nColors = rows(myColors);
    colorIdx = 1:rows(myColors);
    colorIdx = colorIdx - (centerPoint-dataMin)*numel(colorIdx)/(dataMax-dataMin); % idx wrt center point
    colorIdx = scalingIntensity * colorIdx/max(abs(colorIdx));  % scale the range
    colorIdx = sign(colorIdx).*colorIdx.^2;
    colorIdx = colorIdx - min(colorIdx);
    colorIdx = colorIdx*nColors/max(colorIdx)+1;
    newMap = interp1(colorIdx, myColors, 1:nColors);
      if nargout > 1
          % ticks and tickLabels will mark [centerPoint-inc, ... centerPoint+inc, centerPoint+2*inc]
          % on a linear color bar with respect the colors corresponding to the new non-linear colormap
          linear_cValues = linspace(cLim(1), cLim(2), nColors);
          nonlinear_cValues = interp1(1:nColors, linear_cValues, colorIdx);
          tickVals = fliplr(centerPoint:-inc:cLim(1));
          tickVals = [tickVals(1:end-1), centerPoint:inc:cLim(2)];
          ticks = nan(size(tickVals));
          % find what linear_cValues correspond to when nonlinear_cValues==ticks
          for i = 1:numel(tickVals)
              [~, idx] = min(abs(nonlinear_cValues - tickVals(i)));
              ticks(i) = linear_cValues(idx);
          end
          tickLabels = arrayfun(@num2str, tickVals, 'Uniformoutput', false);
      end
  end
