% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MIXTCOMP_getParam.R
\name{getParam}
\alias{getParam}
\alias{getProportion}
\title{Get the estimated parameter}
\usage{
getParam(outMixtComp, var)

getProportion(outMixtComp)
}
\arguments{
\item{outMixtComp}{object of class \emph{MixtCompLearn} or \emph{MixtComp} obtained using \code{mixtCompLearn} or
\code{mixtCompPredict} functions from \code{RMixtComp} package or \code{rmcMultiRun} from \code{RMixtCompIO} package.}

\item{var}{name of the variable to get parameter}
}
\value{
the parameter of the variable
}
\description{
Get the estimated parameter
}
\examples{
if (requireNamespace("RMixtCompIO", quietly = TRUE)) {
  dataLearn <- list(
    var1 = as.character(c(rnorm(50, -2, 0.8), rnorm(50, 2, 0.8))),
    var2 = as.character(c(rnorm(50, 2), rpois(50, 8)))
  )

  model <- list(
    var1 = list(type = "Gaussian", paramStr = ""),
    var2 = list(type = "Poisson", paramStr = "")
  )

  algo <- list(
    nClass = 2,
    nInd = 100,
    nbBurnInIter = 100,
    nbIter = 100,
    nbGibbsBurnInIter = 100,
    nbGibbsIter = 100,
    nInitPerClass = 3,
    nSemTry = 20,
    confidenceLevel = 0.95,
    ratioStableCriterion = 0.95,
    nStableCriterion = 10,
    mode = "learn"
  )

  resLearn <- RMixtCompIO::rmcMultiRun(algo, dataLearn, model, nRun = 3)

  # get estimated parameters for variable var1
  param <- getParam(resLearn, "var1")
  prop <- getProportion(resLearn)
}

}
\seealso{
\code{\link{plotDataBoxplot}}  \code{\link{plotDataCI}}

Other getter: 
\code{\link{getBIC}()},
\code{\link{getCompletedData}()},
\code{\link{getEmpiricTik}()},
\code{\link{getMixtureDensity}()},
\code{\link{getPartition}()},
\code{\link{getType}()}
}
\author{
Quentin Grimonprez
}
\concept{getter}
