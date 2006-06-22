\name{absent}
\docType{data}
\alias{absent}
\non_function{}
\title{Absenteeism data}
\usage{data(absent)}
\description{
The \code{absent} contains data on absenteeism of workers of a medium-sized industrial company in South Germany observed between 01.01.1981 and 31.12.1998.
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{id}{employee's ID}
    \item{absent}{the day of absenteeism}
    \item{status}{1 for the uncensored last day of absenteeism}
    \item{date}{date of the first day of a sick leave}
    \item{day}{day of the first day of a sick leave}
    \item{month}{month}
  }
}
\source{
Kauermann, G and Ortlieb, R. (2004). Temporal pattern in number of staff on sick leave: the effect of downsizing. \emph{Journal of Royal Statistical Society, Series C},
\bold{53}, 353-367.
}
\references{
Krivobokova, T., Crainiceanu, C.M. and Kauermann, G. (2005)\cr
     \emph{Fast Adaptive Penalized Splines} working paper.\cr
     \url{http://www.wiwi.uni-bielefeld.de/~statistics/research/research.html}

}
\examples{
library(AdaptFit)
data(absent)
attach(absent)
}
\keyword{datasets}