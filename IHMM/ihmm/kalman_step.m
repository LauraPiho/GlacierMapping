function [filt_mean, filt_cov, logl] = ...
  kalman_step(filt_mean, filt_cov, A, R, B, S, y);

%kalman_step    One step of Kalman filtering recursion (for time indices
%               after the first one); also returns the conditional log-
%               likelihood.
%
%Use: [filt_mean, filt_cov, logl] = ...
%       kalman_step(filt_mean, filt_cov, A, R, B, S, y); see ex_smth
%for more information on the input arguments.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/14 09:39:01 $

% Prediction
pred_mean = A * filt_mean;
pred_cov = A*filt_cov*A' + R*R';    

% Filtering
% Inovation
inov = y-B*pred_mean;
inov_prec = inv(B*pred_cov*B'+S*S');
% Filter
filt_mean = pred_mean + pred_cov*B'*inov_prec*inov;
filt_cov = pred_cov - pred_cov*B'*inov_prec*B*pred_cov;

% Log-likelihood
logl = -( length(y)*log(2*pi) - log(det(inov_prec)) + inov'*inov_prec*inov )/2;
