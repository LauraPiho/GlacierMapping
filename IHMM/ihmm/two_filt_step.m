function [smth_mean, smth_cov, loglr] = ...
  two_filt_step(filt_mean, filt_cov, kappa, Pi);

%two_filt_step  Two filter formula applied at a single time index (requires
%               prior application of kalman and back_inf); also returns the
%               log of the likelihood ratio ($m_k$ -- see Section 6.3).
%
%Use: [smth_mean, smth_cov, loglr] = ...
%       two_filt_step(filt_mean, filt_cov, kappa, Pi);

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/14 09:39:01 $

% Get state dimension
x_dim = length(filt_mean);

% Smoothing moments
smth_mean = filt_mean + filt_cov * ...
  ((eye(x_dim)+Pi*filt_cov)\(kappa - Pi*filt_mean));
smth_cov = filt_cov - ...
  filt_cov*inv(eye(x_dim)+Pi*filt_cov)*Pi*filt_cov;

% Log of likelihood-ratio
loglr = - ( log(det(filt_cov)) + filt_mean'*(filt_cov\filt_mean) )/2 ...
  + ( log(det(smth_cov)) + smth_mean'*(smth_cov\smth_mean) )/2;
