function I = invert_cdf(p, U);

%invert_cdf     Invert a discrete cumulative distribution function for an
%               input vector of INCREASING numbers between 0 and 1.
%
%Use: I = invert_cdf(p, U); where p is a probability vector and U a vector of
%increasing numbers between 0 and 1. Returns a vector of indices between 1
%and length(p).

% IHMM Toolbox, $Revision: 1.1 $, $Date: 2006/10/25 10:01:17 $

% Number of inversions to be performed
n = length(U);

% Distribution function
F = cumsum(p);

% Compute indices
I = zeros(n, 1);
for t = 1:n
  if (t == 1)
    I(t) = 1;
  else
    I(t) = I(t-1);
  end
  while (U(t) >= F(I(t)))
    I(t) = I(t)+1;
  end
end
