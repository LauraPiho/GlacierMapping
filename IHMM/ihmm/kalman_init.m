function [filt_mean, filt_cov, logl] = kalman_init(x0_mean, x0_cov, B, S, y);

%kalman_init    Initial step of the Kalman filtering recursion; ; also returns
%               the conditional log-likelihood.
%
%Use: [filt_mean, filt_cov, logl] = kalman_init(x0_mean, x0_cov, B, S, y); see
%ex_smth for more information on the input arguments.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/14 09:39:01 $

% Prediction
pred_mean = x0_mean;
pred_cov = x0_cov;

% Filtering
% Inovation
inov = y-B*pred_mean;
inov_prec = inv(B*pred_cov*B'+S*S');
% Filter
filt_mean = pred_mean + pred_cov*B'*inov_prec*inov;
filt_cov = pred_cov - pred_cov*B'*inov_prec*B*pred_cov;

% Log-likelihood
logl = -( length(y)*log(2*pi) - log(det(inov_prec)) + inov'*inov_prec*inov )/2;
