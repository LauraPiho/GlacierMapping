function I = resample(p, n, method)

%resample       Resample n times from a probability vector p.
%
%Use: I = resample(p, n [, method]); where method is one of
%     'indp' (independent)
%     'stra' (stratified)
%     'resd' (residual + stratified)
%     'syst' (systematic)
%     Default if 'stra'.

% Note: 'stra' and 'syst' are a bit faster than 'indp'; 'resd' is an order
% of magnitude longer than the others due to the residual transform.

% IHMM Toolbox, $Revision: 1.2 $, $Date: 2008/03/17 10:22:43 $

% Default method
if (nargin < 3)
  method = 'stra';
end

switch lower(method) 
 case 'indp'
  % 1. Independent (or multinomial) resampling
  U = rand_indp(n);
  I = invert_cdf(p, U);
 case 'stra'
  % Stratified resampling
  U = rand_stra(n);
  I = invert_cdf(p, U);
 case 'resd'
  % Residual resampling (with stratif. resampling in the second stage)
  [I_det, rp, rn] = resd_trans(p, n);
  U = rand_stra(rn);
  I_sto = invert_cdf(rp, U);
  I = [I_det; I_sto];
 case 'syst'
  % Systematic resampling
  U = rand_syst(n);
  I = invert_cdf(p, U);
 otherwise
  error('Unknown resampling method');  
end
