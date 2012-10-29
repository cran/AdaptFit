\name{asp}
\alias{asp}
\title{Fit a semiparametric regression model with spatially adaptive penalized splines}
\description{
\code{asp} fits semiparametric
regression models using the mixed model
representation of penalized splines with spatially adaptive
penalties, based on the "spm" function of the SemiPar-package.
}
\usage{
asp(form,adap=TRUE,random=NULL,group=NULL,family="gaussian",
                spar.method="REML",omit.missing=NULL,niter=20,niter.var=50,tol=1e-06,returnFit=FALSE,weights=NULL,correlation=NULL,control=NULL)
}
\arguments{
  \item{form}{a formula describing the model to be fit. 
          Note, that an intercept is always included, whether 
          given in the formula or not.}
 \item{adap}{TRUE (default) if an adaptive fit should be performed, otherwise the fit is identical to that of function "spm".}
  \item{random}{"random=~1" specifies inclusion of a random intercept
         according to the groups specified by the "group" argument.}
  \item{group}{a vector of labels for specifying groups.}
  \item{family}{for specification of the type of likelihood
                model assumed in the fitting.
                May be "gaussian","binomial" or "poisson".}
  \item{spar.method}{method for automatic smoothing parameter
                     selection. May be "REML" (restricted maximum
                     likelihood) or "ML" (maximum likelihood).}
  \item{omit.missing}{a logical value indicating whether
                fields with missing values are to be
                      omitted.}
  \item{niter}{a maximum number of iterations for the mean estimation, default is 20.}
  \item{niter.var}{a maximum number of iterations for the variance of
    random effects estimation, default is 50.}
  \item{tol}{ tolerance for the convergence criterion. Default is 1e-6.     }
  \item{returnFit}{a logical value indicating whether the fitted object
          should be returned when the maximum number of iterations is
          reached without convergence of the algorithm. Default is
          FALSE.}
\item{weights}{to use only with grouped binary data.}
\item{correlation}{correlation structure of the response; see documentation to
  "nlme".}
\item{control}{see lmeControl in the documentation to
  "nlme".}

}
\value{
  A list object of class \code{"spm"} containing the fitted model.
  The components are:
\item{fitted}{fitted values.}
\item{coef.mean}{estimated mean coefficients.}
\item{design.matrices}{design matrices both for knots und subknots.}
\item{x}{x values.}
\item{knots}{knots.}
\item{y.cov}{estimated covariance matrix of the response.}
\item{random.var}{estimated covariance matrix of the random effects.}
\item{subknots}{subknots.}
\item{coef.random}{estimated spline coefficients of the covariance
  matrix of the random effects.}
\item{var.random.var}{estimated variance of the spline coefficients of
  the covariance matrix of the random effects.}
  \item{fit}{mimics fit object of lme() for
  family="gaussian" and glmmPQL() for family="binomial" or
  family="poisson".}
  \item{info}{information about the inputs.}
  \item{aux}{auxiliary information such as variability
   estimates.}
}
\details{See the SemiPar Users' Manual for details
and examples.
}
\references{Krivobokova, T., Crainiceanu, C.M. and Kauermann, G. (2008)\cr
     Fast Adaptive Penalized Splines.\emph{ Journal of Computational and
     Graphical Statistics. 17(1) 1-20.}

       Ganguli, B. and Wand, M.P. (2005)\cr
     \emph{SemiPar 1.0 Users' Manual}.\cr
     \url{http://www.maths.unsw.edu.au/~wand/papers.html}

Ruppert, D., Wand, M.P. and Carroll, R.J. (2003)\cr
     \emph{Semiparametric Regression} Cambridge University Press.\cr
     \url{http://stat.tamu.edu/~carroll/semiregbook/}
   
 }

\author{Tatyana Krivobokova 
\email{tkrivob at gwdg.de}

}
\seealso{
\code{\link{gam}} (in package `mgcv')
\code{\link{lme}} (in package `nlme')
\code{\link{glmmPQL}} (in package `MASS')
}
\examples{

## scatterplot smoothing

x <- 1:1000/1000
mu <- exp(-400*(x-0.6)^2)+5*exp(-500*(x-0.75)^2)/3+2*exp(-500*(x-0.9)^2)
y <- mu+0.5*rnorm(1000)

#fit with default knots
y.fit <- asp(y~f(x))
plot(y.fit)

## one more scatterplot smoothing with specified knots and subknots

x <- 1:400/400
mu <- sqrt(x*(1-x))*sin((2*pi*(1+2^((9-4*6)/5)))/(x+2^((9-4*6)/5)))
y <- mu+0.2*rnorm(400)

kn <- default.knots(x,80)
kn.var <- default.knots(kn,20)

y.fit <- asp(y~f(x,knots=kn,var.knot=kn.var))
plot(y.fit)


## additive models

x1 <- 1:300/300
x2 <- runif(300)
mu1 <- exp(-400*(x1-0.6)^2)+5*exp(-500*(x1-0.75)^2)/3+2*exp(-500*(x1-0.9)^2)
mu2 <- sin(2*pi*x2)
y2 <- mu1+mu2+0.3*rnorm(300)

y2.fit <- asp(y2~f(x1)+f(x2))
par(mfrow=c(2,2))
y21.fit <- asp(y2~f(x1,adap=FALSE)+f(x2)) #switch off adaptive fitting for the first function
plot(y2.fit)
plot(y21.fit)
par(mfrow=c(1,1))

## spatial smoothing

mu3 <- x1*sin(4*pi*x2)
y3 <- mu3+diff(range(mu3))*rnorm(300)/4


#for the specified knots and subknots use
	# kn <- default.knots.2D(x1,x2,12^2) # !!! interactive function !!!
	# kn.var <- default.knots.2D(kn[,1],kn[,2],5^2)
	# y3.fit <- asp(y3~f(x1,x2,knots=kn,var.knot=kn.var))

## non-normal response

x <- 1:1000/1000
mu <- exp(-400*(x-0.6)^2)+5*exp(-500*(x-0.75)^2)/3+2*exp(-500*(x-0.9)^2)
y4 <- rbinom(1000,5,1/(1+exp(-mu)))
nn <- rep(5,1000)
y4.fit <- asp(cbind(y4,nn-y4)~f(x),family="binomial")
### same as ###  y4.fit <- asp(y4/nn~f(x),family="binomial",weights=nn)
plot(y4.fit) #plot of systematic component


## correlated errors

y5 <- sin(2*pi*x1)+0.3*arima.sim(300,model=list(ar=0.6))

y5.fit <- asp(y5~f(x1),adap=FALSE,correlation=corAR1())
plot(y5.fit)

#see also SemiPar User Manual

#
# The current version of the SemiPar User Manual is posted on the web-site:
#
#     www.maths.unsw.edu.au/~wand/papers.html 
}
\keyword{nonlinear} \keyword{models} \keyword{smooth} \keyword{regression}\keyword{adaptive}

