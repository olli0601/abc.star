% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ftest.R
\name{ftest.calibrate}
\alias{ftest.calibrate}
\title{Calibrating \code{ftest} for ABC}
\usage{
ftest.calibrate(n.of.x = NA, t2.x = NA, n.of.y = NA, p = NA,
  what = "MXPW", mx.pw = 0.9, alpha = 0.01, c = NA, tau = NA,
  tol = 1e-05, max.it = 100, pow_scale = 1.5, use.R = FALSE,
  debug = FALSE, plot = FALSE, verbose = FALSE)
}
\arguments{
\item{p}{Number of variables}

\item{what}{Character string to indicate the type of calibration to be performed}

\item{mx.pw}{Maximum power at the point of equality}

\item{alpha}{Level of the equivalence test}

\item{c}{Upper boundary point of the critical region}

\item{tau}{Upper boundary point of the equivalence region}

\item{tol}{Required error tolerance in calibrating the actual maximum power to the requested maximum power}

\item{max.it}{Maximum number of optimization steps at each calibration hierarchy}

\item{pow_scale}{Scale for the support of the power function (used for plotting)}

\item{plot}{Flag to plot calibrations}

\item{verbose}{Flag to run in verbose mode}

\item{n}{Number of replicate simulations}
}
\value{
vector
}
\description{
Calibrate the one-sample equivalence test for population means of multivariate normal summary values with unknown population covariance matrix for ABC inference.

Different types of calibrations are available, see Notes for details:
\enumerate{ 
 \item (\code{what = ALPHA}) compute the ABC false positive rate for given critical region,
 \item (\code{what = CR}) calibrate the critical region for given ABC false positive rate,
 \item (\code{what = MXPW}) calibrate the critical region and the equivalence region for given ABC false positive rate and maximum power.
}

Depending on the type of calibration, some of the following inputs must be specified (see Examples).
}
\note{
\enumerate{	
 \item (\code{what = ALPHA}) This calibration requires the inputs \code{c}, \code{tau} with \code{0 < tau} and \code{c > 0}. 
				The output contains the corresponding ABC false positive rate \code{alpha}.
				This option does not specify any of the free ABC parameters, but may be useful to determine the ABC
				false positive rate for uncalibrated ABC routines.
 \item (\code{what = CR}) This calibration requires the input \code{tau}, \code{alpha} with \code{tau > 0} and default \code{alpha = 0.01}. 
				The output contains the corresponding critical value \code{c}, which defines critical region \code{[0, c]}, which corresponds to the ABC tolerance region typically denoted by \code{[0, tau]}.
 \item (\code{what=MXPW}) This calibration requires the inputs \code{alpha}, \code{mx.pw}, with default values 0.01 and 0.9 respectively.
				The output contains the corresponding critical value \code{c}, corresponding to critical region \code{[0, c]} (to be used in ABC). It also contains 
				the corresponding squared distance \code{tau}, defining equivalence region \code{[0, tau]} that gives a suitable ABC accept/reject probability if the simulated summary values are close to the observed summary values.
				As a check to the numerical calibrations, the actual power at the point of equality is returned (\code{pw.cmx}).
}
}
\examples{
# calibrating the F-test

# set number of variables (i.e. summary statistics)
p 		<- 3
# set number of observations
n.of.x 	<- 100
# set number of simulations
n.of.y 	<- 100
# set T2 calculated on the observed data
t2.x	<- 0.25

# Example 1: calculate ABC false positive rate for given ABC tolerance
# this requires to specify c, tau2 (ad-hoc ABC parameters), n (the number of 
# simulated data sets) and p (the number of dimensions)
# note: can be useful to compute the ABC false positive rate for uncalibrated ABC routines
ftest.calibrate(n.of.y=n.of.y, p=p, what = 'ALPHA', c = 6.5, tau = 0.21, plot = TRUE)

# Example 2: calibrate critical region for given ABC false positive rate and equivalence region
# this requires to specify alpha (calibration parameters), tau2 (ad-hoc ABC parameter), 
# n (the number of simulated data sets) and p (the number of dimensions)
# note: this is just an intermediate calibration and may result in unsuitable power properties
ftest.calibrate(n.of.y=n.of.y, p=p, what = 'CR', tau = 0.21, alpha = 0.01, plot = TRUE)

# Example 3: calibrate critical region and power of ABC accept/reject step
# this requires to specify alpha, mx.pw (calibration parameters), n (the number of 
# simulated data sets) and p (the number of dimensions)
# note: this is just an intermediate calibration and may result in unsuitable power properties
ftest.calibrate(n.of.y=n.of.y, p=p, what = 'MXPW', mx.pw = 0.9, alpha = 0.01, use.R= TRUE, plot = TRUE)
ftest.calibrate(n.of.y=n.of.y, p=p, what = 'MXPW', mx.pw = 0.9, alpha = 0.01, use.R= FALSE, plot = TRUE)

# Example 4: calibrate critical region, power of ABC accept/reject step, and #simulated data points
# this requires to specify alpha, mx.pw (calibration parameters), and n.of.x, t2.of.x (summary parameters)
# note: this is the default calibration
ftest.calibrate(n.of.x=n.of.x, t2.x=t2.x, p=p, what='KL', mx.pw=0.9, alpha=0.01, use.R= TRUE, plot=TRUE)
ftest.calibrate(n.of.x=n.of.x, t2.x=t2.x, p=p, what='KL', mx.pw=0.9, alpha=0.01, use.R= FALSE, plot=TRUE)

system.time({ for(i in 1:1e4) ftest.calibrate(n.of.x=n.of.x, t2.x=t2.x, p=p, what='KL', mx.pw=0.9, alpha=0.01, use.R= FALSE) })
}
\references{
http://arxiv.org/abs/1305.4283
}
\seealso{
\code{\link{mutost.calibrate}}, \code{\link{vartest.calibrate}}, \code{\link{ratetest.calibrate}}, \code{\link{ztest.calibrate}}
}

