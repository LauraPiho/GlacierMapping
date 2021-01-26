function n = perp(p)

%perp           Compute the Perplexity (exponential of the entropy).
%
%Use: n = per(p);

% IHMM Toolbox, $Revision: 1.2 $, $Date: 2006/12/13 22:55:47 $

% Compute exp(Ent) avoid log of zero
I = find(p > 0);
n = exp(-sum(p(I).*log(p(I))));
