# # MixtComp version 4 - july 2019
# # Copyright (C) Inria - Université de Lille - CNRS
#
# # This program is free software: you can redistribute it and/or modify
# # it under the terms of the GNU Affero General Public License as
# # published by the Free Software Foundation, either version 3 of the
# # License, or (at your option) any later version.
# # This program is distributed in the hope that it will be useful,
# # but WITHOUT ANY WARRANTY; without even the implied warranty of
# # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# # GNU Affero General Public License for more details.
# #
# # You should have received a copy of the GNU Affero General Public License
# # along with this program.  If not, see <https://www.gnu.org/licenses/>
#
#
# ###################################################################################
# #
# # Functions for ClusVis: see with Matthieu to add it to ClusVis once RMixtComp is on CRAN
# #
#
#
# # @title Run clusvis for MixtComp output
# #
# # @description This function estimates the parameters used for visualization of model-based clustering performs with R
# # package ClusVis.
# # To achieve the parameter inference, it automatically samples probabilities of classification from the model parameters
# #
# #
# # @param resMixtComp list. It is an object return by MixComp.
# # @param sample.size numeric. Number of probabilities of classification sampled for parameter inference.
# # @param maxit numeric. It limits the number of iterations for the Quasi-Newton algorithm (default 1000).
# # @param nbrandomInit numeric. It defines the number of random initialization of the Quasi-Newton algorithm.
# # @param nbcpu numeric. It specifies the number of CPU (only for linux, R package parallel must by loaded).
# # @param estimateLogTik if TRUE, estimate the logtik. If FALSE, use the logtik returned by MixtComp
# #
# # @details
# # See \link{plotComponentClusVis} and \link{plotObservationsClusVis} for graphics outputs.
# #
# # @examples
# # library(RMixtComp)
# #
# # data(titanic)
# #
# # # define the algorithm's parameters
# # algo <- createAlgo()
# #
# # # run RMixtComp in unsupervised clustering mode + data as matrix
# # res <- mixtCompLearn(simData$dataLearn$matrix, simData$model$unsupervised, algo, nClass = 2:4)
# #
# # resvisu <- clusvisMixtComp(res)
# #
# # @seealso \code{\link{plotComponentClusVis}} \code{\link{plotObservationsClusVis}}
# # @author Matthieu Marbac
# # @export
# clusvisMixtComp <- function(resMixtComp, sample.size = 5000, maxit = 10**3, nbrandomInit = 12, nbcpu = 1, estimateLogTik = FALSE){
#
#   if(estimateLogTik)
#   {
#     logtik.estim <- t(replicate(sample.size, rlogtikMixtComp(resMixtComp)))
#     out <- clusvis(logtik.estim, prop = resMixtComp$variable$param$z_class$stat[,1], logtik.obs = logMixtComp(resMixtComp), maxit, nbrandomInit, nbcpu)
#   }else{
#     out <- clusvis(getTik(resMixtComp, log = TRUE), prop = resMixtComp$variable$param$z_class$stat[,1], logtik.obs = getTik(resMixtComp, log = TRUE), maxit, nbrandomInit, nbcpu)
#   }
#
#   return(out)
# }
#
# ###################################################################################
# # @name plotComponentClusVis
# #
# # @title ClusVis plots
# #
# # @description plotComponentClusVis is a wrapper around the plotDensityClusVisu function of the ClusVis package. It generates
# # a component interpretation graph using the visualization information returned by the clusvisMixtcomp function.
# # plotObservationsClusVis is a wrapper around the plotDensityClusVisu function of the ClusVisu package. It generates
# # a scatter-plot of the observation memberships using the visualization information returned by the clusvisMixtcomp function.
# #
# #
# # @param visInfo list. The parameters estimated by the clusvisMixtcomp function.
# #
# # @examples
# # \donttest{
# # library(RMixtComp)
# #
# # data(simData)
# #
# # # define the algorithm's parameters
# # algo <- createAlgo()
# #
# # # run RMixtComp in unsupervised clustering mode + data as matrix
# # res <- mixtCompLearn(simData$dataLearn$matrix, simData$model$unsupervised, algo, nClass = 2:4)
# #
# #
# # # Use ClusVis with RMixtComp
# # library(ClusVis)
# #
# # # run clusvis
# # resVisu <- ClusVis::clusvis(getTik(res, log = TRUE), prop = res$variable$param$z_class$stat[,1], logtik.obs = getTik(res, log = TRUE))
# #
# # # plot results
# # plotComponentClusVis(resVisu)
# # plotObservationsClusVis(resVisu)
# #
# # }
# #
# # @author Matthieu Marbac
# # @export
# plotComponentClusVis <- function(visInfo) {
#   plotDensityClusVisu(visInfo, add.obs = FALSE, positionlegend = "bottomright",
#                       xlim = range(visInfo$centers[,1])+c(-4,6), ylim = range(visInfo$centers[,2])+c(-6,4))
# }
#
# ###################################################################################
# # @rdname plotComponentClusVis
# # @author Matthieu Marbac
# # @export
# plotObservationsClusVis <- function(visInfo) {
#   plotDensityClusVisu(visInfo, add.obs = TRUE, positionlegend = "bottomright",
#                       xlim = range(visInfo$y[,1])+c(0,2), ylim = range(visInfo$y[,2])+c(-2,0))
# }
#
#
#
# # This function returns the log-probabilites of classification for each observation
# # It takes one input argument (named output) returned by the function rMixtComp
# # It returns a matrix of the logarithm of the probabilities of classification
# # Rows correspond to observations and column correspond to component
# # Here, few types of data are allowed: continuous or categorical
# # The other types of data must be implemented
# # @author Matthieu Marbac
# logMixtComp <- function(output){
#   param <- output$variable$param
#   x <- output$variable$data
#   logtik <- matrix(0, length(x$z_class$completed), output$algo$nClass)
#   for (k in 1:output$algo$nClass)
#     logtik[,k] <- log(param$z_class$stat[k,1])
#
#   for (j in 2:length(x)){
#     if (output$variable$type[[j]] == "Gaussian"){
#       for (k in 1:ncol(logtik)){
#         tmp <- matrix(param[[j]]$stat[,1], nrow = 2, ncol = output$algo$nClass)
#         logtik[,k] <- logtik[,k] + dnorm(x[[j]]$completed, tmp[1,k], tmp[2,k], log = TRUE)
#       }
#     } else if (output$variable$type[[j]] == "Multinomial"){
#       for (k in 1:ncol(logtik)){
#         tmp <- log(matrix(param[[j]]$stat[,1], ncol = output$algo$nClass))
#         logtik[,k] <- logtik[,k] + tmp[x[[j]]$completed, k]
#       }
#     } else if (output$variable$type[[j]] == "Poisson"){
#       for (k in 1:ncol(logtik)){
#         tmp <- matrix(param[[j]]$stat[,1], nrow = 1, ncol = output$algo$nClass)
#         logtik[,k] <- logtik[,k] + dpois(x[[j]]$completed, tmp[1,k], log = TRUE)
#       }
#     } else if (output$variable$type[[j]] == "Weibull"){
#       for (k in 1:ncol(logtik)){
#         tmp <- matrix(param[[j]]$stat[,1], nrow = 2, ncol = output$algo$nClass)
#         logtik[,k] <- logtik[,k] + dweibull(x[[j]]$completed, shape = tmp[1,k], scale = tmp[2,k], log = TRUE)
#       }
#     } else if (output$variable$type[[j]] == "NegativeBinomial"){
#       for (k in 1:ncol(logtik)){
#         tmp <- matrix(param[[j]]$stat[,1], nrow = 2, ncol = output$algo$nClass)
#         logtik[,k] <- logtik[,k] + dnbinom(x[[j]]$completed, mu = tmp[1,k], p = tmp[2,k], log = TRUE)
#       }
#     } else{
#       stop("this type of variable is not implemented")
#     }
#
#   }
#   logtik <- sweep(logtik, 1, apply(logtik, 1, max), "-")
#   logtik <- sweep(logtik, 1, log(rowSums(exp(logtik))), "-")
#   logtik
# }
#
# # This function returns the log-density per component of a single observation "x"
# # according to its "type", its parameters "p" for the "g" components
# # Here, few types of data are allowed: continuous or categorical
# # The other types of data must be implemented
# # @author Matthieu Marbac
# dlogSingleMixtComp <- function(x, p, type, g){
#   dlog <- rep(0, g)
#   if (type == "Gaussian"){
#     p <- matrix(p, g, 2)
#     dlog <- dnorm(x, p[,1], p[,2], log = TRUE)
#   } else if (type == "Multinomial"){
#     m <- length(p) / g
#     p <- matrix(p, m, g)
#     dlog <- log(p[x,])
#   } else if (type == "Poisson") {
#     p <- matrix(p, g, 1)
#     dlog <- dpois(x, p[,1], log = TRUE)
#   } else if (type == "Weibull") {
#     p <- matrix(p, g, 2)
#     dlog <- dweibull(x, shape = p[,1], scale = p[, 2], log = TRUE)
#   } else if (type == "NegativeBinomial") {
#     p <- matrix(p, g, 2)
#     dlog <- dnbinom(x, mu = p[,1], p = p[, 2], log = TRUE)
#   } else {
#     stop("this type of variable is not implemented")
#   }
#   dlog
# }
#
# # This function samples a single observation from the component "z"
# # for the variable of type "type" and parameters "p".
# # Here, few types of data are allowed: continuous or categorical
# # The other types of data must be implemented
# # @author Matthieu Marbac
# rsingleMixtComp <- function(p, type, z, g, Tseq = NULL){
#   x <- switch(type,
#               "Gaussian" = rnorm(1, p[1+(z-1)*2], p[2+(z-1)*2]),
#               "Multinomial" = {
#                 m <- length(p) / g
#                 sample(1:m, 1, prob=p[m*(z-1) + (1:m)])
#               },
#               "Poisson" = rpois(1, p[z]),
#               "NegativeBinomial" = rnbinom(1, mu = p[1+(z-1)*2], size = p[2+(z-1)*2]),
#               "Weibull" = rweibull(1, shape = p[1+(z-1)*2], scale = p[2+(z-1)*2]),
#               stop("this type of variable is not implemented")
#   )
#
#   x
# }
#
# # This function generates a sample from the model defined by the object output returned
# # by the R package Rmixtcomp
# # @author Matthieu Marbac
# rMixtComp <- function(output){
#   z <- sample(1:output$algo$nClass, 1, prob = output$variable$param$z_class$stat[,1])
#   x <- sapply(1:(length(output$variable$param)-1),
#               function(j, output, z) rsingleMixtComp(output$variable$param[[j+1]]$stat[,1], output$variable$type[[j+1]], z, output$algo$nClass),
#               output = output,
#               z = z)
#   names(x) <- names(output$variable$type)[-1]
#   x
# }
#
# # This function generates a sample of the logarithm of probabilities of classification
# # defined by the model and its parameters given by the object output returned
# # by the R package Rmixtcomp
# # @author Matthieu Marbac
# rlogtikMixtComp <- function(output){
#   x <- rMixtComp(output)
#   dlog <- rowSums(sapply(1:(length(output$variable$param)-1),
#                          function(j, output, x) dlogSingleMixtComp(x[j], output$variable$param[[j+1]]$stat[,1], output$variable$type[[j+1]], output$algo$nClass),
#                          output = output,
#                          x = x)) + log(output$variable$param$z_class$stat[,1])
#   dlog <- dlog - max(dlog)
#   dlog <- dlog - log(sum(exp(dlog)))
#   return(dlog)
# }
#
