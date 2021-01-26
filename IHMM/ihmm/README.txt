IHMM: A set of matlab/octave functions
used in the book "Inference in Hidden
Markov Models" by O. Cappé, T. Rydén
and E. Moulines (Springer Series in
Statistics, 2005).
______________________________________


1. Smoothing algorithms (Section 5.2)
_____________________________________
back_inf       Backward Information Recursion.
dist_smth      Disturbance (Bryson-Frazier) smoother.
ex_smth        Script to illustrate the use of the smothing functions.
kalman         Kalman filtering; also returns the log-likelihood
kalman_init    Initial step of the Kalman filtering recursion; ; also returns
kalman_step    One step of Kalman filtering recursion (for time indices
rts            RTS backward smoothing (requires prior application of kalman).
two_filt       Two-filter formula (requires prior application of kalman and
two_filt_step  Two filter formula applied at a single time index (requires

Please see the ex_smth script for an example of how to use these functions.


2. Resampling algorithms (Section 7.4)
______________________________________
ess            Compute the Effective Sample Size.
invert_cdf     Invert a discrete cumulative distribution function for an
perp           Compute the Perplexity (exponential of the entropy).
rand_indp      Generate the order statistics of an independent draw of n
rand_stra      Generate n random numbers between 0 and 1 with the
rand_syst      Generate n random numbers between 0 and 1 using systematic
resample       Resample n times from a probability vector p.
resd_trans     Residual transform (Truncate a probability vector to its

Please see the help of resample for more information on these.


--
Olivier Cappé (cappe at telecom-paristech.fr)

IHMM Toolbox, $Revision: 1.4 $, $Date: 2010-02-10 12:30:44 $
