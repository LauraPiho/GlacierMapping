
function [lat,lon]=CartToGeo(x,y,z)
a = 6378137;
e = 8.1819190842622e-2;
b   = sqrt(a^2*(1-e^2));

e2 = (a.^2-b.^2)./b.^2;
%v = a ./ sqrt(1 - e^2 .* sin(lat).^2);
p = sqrt(x.^2 + y.^2);

phi = atand((a.*z)./(b.*p));
lon = atand(y./x);
lat = atand(((z)+b.*e2.*sin(phi).^3)./((p)+a.*e2.*cos(phi).^3));
%alt = ((p)./cos(phi)) - v;