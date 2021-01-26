function [smth_mean, smth_cov] = two_filt(filt_mean, filt_cov, kappa, Pi);

%two_filt       Two-filter formula (requires prior application of kalman and
%               back_inf).
%
%Use: [smth_mean, smth_cov] = two_filt(filt_mean, filt_cov, kappa, Pi);

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/13 22:56:18 $

% Get dimensions
n = size(filt_mean,3);
x_dim = size(filt_mean,1);

% Declare arrays
smth_mean = zeros(x_dim,1,n);
smth_cov = zeros(x_dim,x_dim,n);

% Compute smoothed estimate (order doesn't matters here)
for k = n:-1:1
  % Recopy parameters
  mean_tmp = filt_mean(:,:,k);
  cov_tmp = filt_cov(:,:,k);
  kappa_tmp = kappa(:,:,k);
  Pi_tmp = Pi(:,:,k);
  % Two-filter formula
  smth_mean(:,:,k) = mean_tmp + cov_tmp * ...
    ((eye(x_dim)+Pi_tmp*cov_tmp)\(kappa_tmp - Pi_tmp*mean_tmp));
  smth_cov(:,:,k) = cov_tmp - ...
    cov_tmp*inv(eye(x_dim)+Pi_tmp*cov_tmp)*Pi_tmp*cov_tmp;
end
