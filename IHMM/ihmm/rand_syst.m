function U = rand_syst(n)

%rand_syst      Generate n random numbers between 0 and 1 using systematic
%               sampling.
%
%Use: U = rand_syst(n);

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/10/25 10:01:17 $

% Stratification (only one random draw is used)
U = ((1:n)-rand)/n;
