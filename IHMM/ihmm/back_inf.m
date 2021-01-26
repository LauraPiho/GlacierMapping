function [kappa, Pi] = back_inf(A, R, B, S, y);

%back_inf       Backward Information Recursion.
%
%Use: [kappa, Pi] = back_inf(A, R, B, S, y); see ex_smth for more
%information on the input arguments.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/12/13 22:56:18 $

% Get dimensions
n = size(y,3);
da = size(A,3);
dr = size(R,3);
db = size(B,3);
ds = size(S,3);
x_dim = size(A,1);

% Declare arrays
kappa = zeros(size(A,1),1,n);
Pi = zeros(size(A,1),size(A,2),n);

% Backward information recursion (for k = n, kappa an Pi = 0)
for k = n-1:-1:1
  % Recopy parameters in two dimensional arrays
  kappa_tmp = kappa(:,:,k+1);
  Pi_tmp = Pi(:,:,k+1);
  B_tmp = B(:,:,min(k+1,db)); % This avoids repeating the
  S_tmp = S(:,:,min(k+1,ds)); % parameters in homogeneous models
  y_tmp = y(:,:,k+1);
  A_tmp = A(:,:,min(k,da));
  R_tmp = R(:,:,min(k,dr));
  % Backward recursion formula
  kappa_tmp = B_tmp'*((S_tmp*S_tmp')\y_tmp)+kappa_tmp;
  Pi_tmp = B_tmp'*inv(S_tmp*S_tmp')*B_tmp + Pi_tmp;
  kappa(:,:,k) = A_tmp'*((eye(x_dim)+Pi_tmp*R_tmp*R_tmp')\kappa_tmp);
  Pi(:,:,k) = A_tmp'*inv(eye(x_dim)+Pi_tmp*R_tmp*R_tmp')*Pi_tmp*A_tmp;
end

% Note: recopy could be avoided (at the cost of readibility); in the
% case of homogeneous models, the copy should be done only once.
