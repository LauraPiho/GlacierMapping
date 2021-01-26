function [I, rp, rn] = resd_trans(p, n)

%resd_trans     Residual transform (Truncate a probability vector to its
%               residual interger part).
%
%Use: [I, rp, rn] = resd_trans(p, n); where p is a probability vector and n
%the desired number of points. Returns the corresponding indices I, the
%number of residual indices rn and the residual probability vector rp.

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/10/25 10:01:17 $

p_n = p*n;
p_cnt = floor(p_n);

% The indices
I = zeros(sum(p_cnt),1);
i_cur = 1;
for i = 1:length(p)
  if p_cnt(i) > 0
    I(i_cur:i_cur+p_cnt(i)-1) = i*ones(1,p_cnt(i));
    i_cur = i_cur + p_cnt(i);
  end
end

% Number of residual indices 
rn = n - length(I);

% Residual probabilities
if (rn > 0)
  rp = (p_n - p_cnt)/rn;
else
  % Everything has been allocated, nothing to do
  rp = zeros(size(p));
end
