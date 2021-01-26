function n = ess(p)

%ess            Compute the Effective Sample Size.
%
%Use: n = ess(p);

% IHMM Toolbox, $Revision: 1.2 $, $Date: 2006/12/13 22:55:47 $

n = 1/sum(p.^2);
