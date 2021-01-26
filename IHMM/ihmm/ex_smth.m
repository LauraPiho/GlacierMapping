%ex_smth        Script to illustrate the use of the smoothing functions.
%
%This just performs a sanity check to verify that all three approaches of
%smoothing (RTS, two filter and disturbance) give identical results both on
%a non-homogenous and an homogeneous example. Also serves as an example of
%how to use the functions; please read the comments in the source.

% IHMM Toolbox, $Revision: 1.3 $, $Date: 2006/12/14 09:39:01 $

clear all;


% 1. First on a non-homogeneous noisy AR(2) model
n = 10;
% A priori mean and covariance of the initial state
x0_mean = ones(3,1);
x0_cov =  eye(3);
% System matrices: notations as in the book; the time dimension is the
% third one; the system changes at index 5 (just an example!)
for i = 1:n
  if (i == 5)
    A(:,:,i) = [1 -0.5 0.2; 0 1 0; 0 0 1];
    R(:,:,i) = [0.1 0 0]';
    B(:,:,i) = [1 0 0];
    S(:,:,i) = 0.5;
  else
    if (i < n) % State transition parameters are not needed for last index
      A(:,:,i) = [1 -0.1 0.8; 0 1 0; 0 0 1];
      R(:,:,i) = [0.5 0 0]';
    end  
    B(:,:,i) = [2 0 0];
    S(:,:,i) = 0.2;
  end
end
% Silly observations (here again the time dimension is the third one: in
% this example the observations are scalar)
y = randn(1,1,n);

% Kalman
[pred_mean, pred_cov, filt_mean, filt_cov, logl] = ...
   kalman(x0_mean, x0_cov, A, R, B, S, y);
% RTS smoothing
[smth_mean1, smth_cov1] = rts(A, R, filt_mean, filt_cov);
% Backward information recursion
[kappa, Pi] = back_inf(A, R, B, S, y);
% Two-filter formula
[smth_mean2, smth_cov2] = two_filt(filt_mean, filt_cov, kappa, Pi);
% Disturbance smoother
[smth_mean3, smth_cov3] = dist_smth(x0_mean, x0_cov, A, R, B, S, y);

% Check that the three approaches provide identical results (this be should on
% the order of the relative precision that is 1E-14 to 1E-16)
max(max(abs(smth_mean1-smth_mean2)))
max(max(max(abs(smth_cov1-smth_cov2))))
max(max(abs(smth_mean1-smth_mean3)))
max(max(max(abs(smth_cov1-smth_cov3))))


% 2. For an homogeneous model, we can avoid the third dimension and simply
% give the (two-dimensional) system matrices as arguments to all the
% routines:
% Kalman
[pred_mean, pred_cov, filt_mean, filt_cov, logl] = ...
   kalman(x0_mean, x0_cov, A(:,:,1), R(:,:,1), B(:,:,1), S(:,:,1), y);
% RTS smoothing
[smth_mean4, smth_cov4] = rts(A(:,:,1), R(:,:,1), filt_mean, filt_cov);
% Backward information recursion
[kappa, Pi] = back_inf(A(:,:,1), R(:,:,1), B(:,:,1), S(:,:,1), y);
% Two-filter formula
[smth_mean5, smth_cov5] = two_filt(filt_mean, filt_cov, kappa, Pi);
% Disturbance smoother
[smth_mean6, smth_cov6] = ...
  dist_smth(x0_mean, x0_cov, A(:,:,1), R(:,:,1), B(:,:,1), S(:,:,1), y);

% Check again that the three approaches provide identical results
max(max(abs(smth_mean4-smth_mean5)))
max(max(max(abs(smth_cov4-smth_cov5))))
max(max(abs(smth_mean5-smth_mean6)))
max(max(max(abs(smth_cov5-smth_cov6))))
% If you run this script several times, you will notice that the
% differences pertaining to covariance matrices do not change, which is
% normal since those do not depend on the observations.


% 3. Finally, if you plan to code algorithm 6.3.4 for some model you will
% need to implement single steps of these recursions (since the model
% changes with the imputation of the state variables). Recommended way of
% doing this is:
% Run the backward information recursion
[kappa, Pi] = back_inf(A, R, B, S, y);
% Run Kalman filtering forward, computing the smothing distributions on the
% way, the indicator sampling step could be inserted just after the call to
% two_filt_step
[filt_mean, filt_cov, logl] = ...
  kalman_init(x0_mean, x0_cov, B(:,:,1), S(:,:,1), y(:,:,1));
[smth_mean, smth_cov, loglr] = ...
        two_filt_step(filt_mean, filt_cov, kappa(:,:,1), Pi(:,:,1));
for i = 2:n
  [filt_mean, filt_cov, logl] = kalman_step(filt_mean, filt_cov, ...
    A(:,:,i-1), R(:,:,i-1), B(:,:,i), S(:,:,i), y(:,:,i));
  [smth_mean, smth_cov, loglr] = ...
    two_filt_step(filt_mean, filt_cov, kappa(:,:,i), Pi(:,:,i));
  % If you want to check again the consistency of smoothing computations,
  % uncomment the following lines (not screen friendly though)
  %max(max(abs(smth_mean-smth_mean1(:,:,i))))
  %max(max(max(abs(smth_cov-smth_cov1(:,:,i)))))
end
