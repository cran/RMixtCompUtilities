% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PLOT_plotUnivariateBoxplots.R
\name{plotDataBoxplot}
\alias{plotDataBoxplot}
\title{Boxplot per class}
\usage{
plotDataBoxplot(
  output,
  var,
  class = seq_len(output$algo$nClass),
  grl = TRUE,
  pkg = c("ggplot2", "plotly"),
  ...
)
}
\arguments{
\item{output}{object returned by \emph{mixtCompLearn} function from \emph{RMixtComp} or \emph{rmcMultiRun} function
from \emph{RMixtCompIO}}

\item{var}{name of the variable}

\item{class}{classes to plot}

\item{grl}{if TRUE plot the general distribution of the data}

\item{pkg}{"ggplot2" or "plotly". Package used to plot}

\item{...}{other parameters (see \emph{Details})}
}
\description{
Display a boxplot (5%-25%-50%-75%-95% quantile) for the given variable for all classes
}
\details{
For functional data, three other parameters are available:
\describe{
 \item{add.obs}{if TRUE, observations are added to the plot. Default = FALSE.}
 \item{ylim}{ylim of the plot.}
 \item{xlim}{xlim of the plot.}
}
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

  resLearn <-RMixtCompIO::rmcMultiRun(algo, dataLearn, model, nRun = 3)

  # plot
  plotDataBoxplot(resLearn, "var1")
}

}
\seealso{
Other plot: 
\code{\link{heatmapClass}()},
\code{\link{heatmapTikSorted}()},
\code{\link{heatmapVar}()},
\code{\link{histMisclassif}()},
\code{\link{plot.MixtComp}()},
\code{\link{plotConvergence}()},
\code{\link{plotDataCI}()},
\code{\link{plotDiscrimClass}()},
\code{\link{plotDiscrimVar}()},
\code{\link{plotParamConvergence}()},
\code{\link{plotProportion}()}
}
\author{
Matthieu MARBAC
}
\concept{plot}
