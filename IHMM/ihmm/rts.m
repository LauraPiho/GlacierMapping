function [smth_mean, smth_cov] = rts(A, R, filt_mean, filt_cov);

%rts            RTS backward smoothing (requires prior application of kalman).
%
%Use:  [smth_mean, smth_cov] = rts(A, R, filt_mean, filt_cov); see ex_smth
%for more information on the input arguments.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/13 22:56:18 $

% Get dimensions
n = size(filt_mean,3);
da = size(A,3);
dr = size(R,3);

% Declare arrays
smth_mean = zeros(size(filt_mean,1),1,n);
smth_cov = zeros(size(filt_cov,1),size(filt_cov,2),n);

% Backward smoothing
for k = n:-1:1
  if (k == n)
    smth_mean(:,:,n) = filt_mean(:,:,n);
    smth_cov(:,:,n) = filt_cov(:,:,n);
  else
    % Recopy parameters
    A_tmp = A(:,:,min(k,da)); % To avaoid repeating parmeters in homogeneous
    R_tmp = R(:,:,min(k,dr)); % models
    mean_tmp = filt_mean(:,:,k);
    cov_tmp = filt_cov(:,:,k);
    % RTS recursion
    smth_mean(:,:,k) = mean_tmp + cov_tmp*A_tmp' * ...
      ( (A_tmp*cov_tmp*A_tmp'+R_tmp*R_tmp') \ ...
      (smth_mean(:,:,k+1)-A_tmp*mean_tmp) );
    smth_cov(:,:,k) = cov_tmp - ...
      cov_tmp*A_tmp'*inv(A_tmp*cov_tmp*A_tmp'+R_tmp*R_tmp')*A_tmp*cov_tmp + ...
      cov_tmp*A_tmp'*inv(A_tmp*cov_tmp*A_tmp'+R_tmp*R_tmp') * ...
        smth_cov(:,:,k+1) * ...
      inv(A_tmp*cov_tmp*A_tmp'+R_tmp*R_tmp')*A_tmp*cov_tmp;
  end
end

% Note: recopy could be avoided (at the cost of readibility); in the
% case of homogeneous models, the copy should be done only once.
