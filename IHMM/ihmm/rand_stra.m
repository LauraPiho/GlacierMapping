function U = rand_stra(n)

%rand_stra      Generate n random numbers between 0 and 1 with the
%               stratified sampling scheme.
%
%Use: U = rand_stra(n);

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/10/25 10:01:17 $

% Independent uniform draws
U = rand(1, n);

% Stratification (with n levels)
U = ((0:n-1)+U)/n;
