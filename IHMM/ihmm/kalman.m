function [pred_mean, pred_cov, filt_mean, filt_cov, logl] = ...
    kalman(x0_mean, x0_cov, A, R, B, S, y);

%kalman         Kalman filtering; also returns the log-likelihood
%               of the observation sequence.
%
%Use: [pred_mean, pred_cov, filt_mean, filt_cov, logl] = ...
%       kalman(x0_mean, x0_cov, A, R, B, S, y); see ex_smth for more
%information on the input arguments.

% IHMM Toolbox, $Revision: 1.2 $, $Date: 2006/12/14 09:38:43 $

% Get dimensions
n = size(y,3);
da = size(A,3);
dr = size(R,3);
db = size(B,3);
ds = size(S,3);
y_dim = size(y,1);

% Declare arrays
pred_mean = zeros(size(x0_mean,1),1,n);
filt_mean = zeros(size(x0_mean,1),1,n);
pred_cov = zeros(size(x0_cov,1),size(x0_cov,2),n);
filt_cov = zeros(size(x0_cov,1),size(x0_cov,2),n);
logl = zeros(1,n);

% Fitering recusion
for k = 1:n
  % Prediction
  if (k == 1)
    pred_mean(:,:,1) = x0_mean;
    pred_cov(:,:,1) = x0_cov;
  else
    % Recopy parameters
    mean_tmp = filt_mean(:,:,k-1);
    cov_tmp = filt_cov(:,:,k-1);
    A_tmp = A(:,:,min(k-1,da)); % See below ...
    R_tmp = R(:,:,min(k-1,dr));
    % Kalman prediction update
    pred_mean(:,:,k) = A_tmp * mean_tmp;
    pred_cov(:,:,k) = A_tmp*cov_tmp*A_tmp' + R_tmp*R_tmp';    
  end
  % Filtering
  % Recopy parameter
  mean_tmp = pred_mean(:,:,k);
  cov_tmp = pred_cov(:,:,k);
  B_tmp = B(:,:,min(k,db)); % To avoid repeating the
  S_tmp = S(:,:,min(k,ds)); % parameters in homogenous models
  y_tmp = y(:,:,k);
  % Kalman filter update
  % Inovation
  inov = y_tmp-B_tmp*mean_tmp;
  inov_prec = inv(B_tmp*cov_tmp*B_tmp'+S_tmp*S_tmp');
  % Filter
  filt_mean(:,:,k) = mean_tmp + cov_tmp*B_tmp'*inov_prec*inov;
  filt_cov(:,:,k) = cov_tmp - cov_tmp*B_tmp'*inov_prec*B_tmp*cov_tmp;
  % Log-likelihood
  logl(k) = -( y_dim*log(2*pi) - log(det(inov_prec)) ...
    + inov'*inov_prec*inov )/2;
end

% Note: recopy could be avoided (at the cost of readibility); in the
% case of homogeneous models, the copy should be done only once.
