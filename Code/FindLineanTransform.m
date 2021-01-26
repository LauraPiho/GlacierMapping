%% function to find linear transformation from normalised to ecef
function [transform] = FindLineanTransform(CartCoordinates, NormEst)

[x1,x2] = start_end(CartCoordinates);
[y1,y2] = start_end(NormEst);

transform = zeros(3,2);
for i = 1:3
A = [y1(i) 1;y2(i) 1];
b = [x1(i) ;x2(i)];
transform(i,:) = A\b;
end
