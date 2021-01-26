function [smth_mean, smth_cov, smth_crosscov] = dist_smth(x0_mean, x0_cov, A, R, B, S, y);

%dist_smth      Disturbance (Bryson-Frazier) smoother.
%
%Use: [smth_mean, smth_cov, smth_crosscov] =
%       dist_smth(x0_mean, x0_cov, A, R, B, S, y); see ex_smth for more
%information on the input arguments.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/13 22:56:18 $

% Get dimensions
n = size(y,3);
da = size(A,3);
dr = size(R,3);
db = size(B,3);
ds = size(S,3);
y_dim = size(y,1);
x_dim = size(x0_mean,1);
u_dim = size(R,2);

% Forward prediction (Kalman)
% Declare arrays
inov = zeros(y_dim,1,n);
inov_prec = zeros(y_dim,y_dim,n);
pred_cov = zeros(x_dim,x_dim,n);
Lambda = zeros(x_dim,x_dim,n);
% Initial prediction
pred_mean = x0_mean;
pred_cov(:,:,1) = x0_cov;
% Recursion
for k = 1:n
  % Filtering
  % Recopy parameters
  cov_tmp = pred_cov(:,:,k);
  B_tmp = B(:,:,min(k,db)); % To avoid repeating the
  S_tmp = S(:,:,min(k,ds)); % parameters in homogenous models
  y_tmp = y(:,:,k);
  % Inovation
  inov(:,:,k) = y_tmp-B_tmp*pred_mean;
  inov_prec(:,:,k) = inv(B_tmp*cov_tmp*B_tmp'+S_tmp*S_tmp');
  % Next prediction
  % Recopy parameters
  A_tmp = A(:,:,min(k,da));
  R_tmp = R(:,:,min(k,dr));
  % Prediction
  kalman = A_tmp*cov_tmp*B_tmp'*inov_prec(:,:,k);
  Lambda(:,:,k) = A_tmp-kalman*B_tmp;
  if (k < n)
    pred_mean = A_tmp*pred_mean + kalman*inov(:,:,k);
    pred_cov(:,:,k+1) = Lambda(:,:,k)*cov_tmp*A_tmp'+R_tmp*R_tmp';
  end
end

% Backward disturbance smoothing
% Declare arrays
p = zeros(x_dim,1,n-1);
C = zeros(x_dim,x_dim,n-1);
u = zeros(u_dim,1,n-1);
Xi = zeros(u_dim,u_dim,n-1);
% Bacward recursion
for k = n-1:-1:1
 if (k == (n-1))
   B_tmp = B(:,:,min(n,db));
   p(:,:,n-1) = B_tmp'*inov_prec(:,:,n)*inov(:,:,n);
   C(:,:,n-1) = B_tmp'*inov_prec(:,:,n)*B_tmp;
 else
   B_tmp = B(:,:,min(k+1,db));   
   p(:,:,k) = B_tmp'*inov_prec(:,:,k+1)*inov(:,:,k+1) + ...
       Lambda(:,:,k+1)'*p(:,:,k+1);
   C(:,:,k) = B_tmp'*inov_prec(:,:,k+1)*B_tmp + ...
       Lambda(:,:,k+1)'*C(:,:,k+1)*Lambda(:,:,k+1);   
 end
 R_tmp = R(:,:,min(k,dr));
 u(:,:,k) = R_tmp'*p(:,:,k);
 Xi(:,:,k) = eye(u_dim) - R_tmp'*C(:,:,k)*R_tmp;
end

% Final forward recursion for state smoothing
% Declare arrays
smth_mean = zeros(x_dim,1,n);
smth_cov = zeros(x_dim,x_dim,n);
smth_crosscov = zeros(x_dim,x_dim,n-1);
% Initial state
smth_mean(:,:,1) = x0_mean + ...
  x0_cov*( B(:,:,1)'*inov_prec(:,:,1)*inov(:,:,1) + Lambda(:,:,1)'*p(:,:,1) );
smth_cov(:,:,1) = x0_cov - x0_cov*( B(:,:,1)'*inov_prec(:,:,1)*B(:,:,1) ...
  + Lambda(:,:,1)'*C(:,:,1)*Lambda(:,:,1) )*x0_cov;
% Recusion
for k = 2:n
  A_tmp = A(:,:,min(k-1,da));
  R_tmp = R(:,:,min(k-1,dr));
  % Cross covariance with previous state
  tmp = pred_cov(:,:,k-1)*Lambda(:,:,k-1)'*C(:,:,k-1)*R_tmp*R_tmp';
  smth_crosscov(:,:,k-1) = smth_cov(:,:,k-1)*A_tmp'-tmp;
  % Mean
  smth_mean(:,:,k) = A_tmp*smth_mean(:,:,k-1) + R_tmp*u(:,:,k-1);
  % Covariance
  smth_cov(:,:,k) = A_tmp*smth_cov(:,:,k-1)*A_tmp' ...
    + R_tmp*Xi(:,:,k-1)*R_tmp' ...
    - A_tmp*tmp - tmp'*A_tmp';
end

% Note: recopy could be avoided (at the cost of readibility); in the
% case of homogeneous models, the copy should be done only once.
