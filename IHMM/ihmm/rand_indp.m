function U = rand_indp(n)

%rand_indp      Generate the order statistics of an independent draw of n
%               uniform(0,1) variables.
%
%Use: U = rand_indp(n);

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/10/25 10:01:17 $

% Just sort
U = sort(rand(1,n));

% In theory the method below should be slightly faster for large values of n
% but it never is in matlab...
%
%% Random draws
%U = rand(1, n);
%
%% Transformation (after Malmquist, 1950)
%U = fliplr(cumprod(U.^(1./(n:-1:1))));
