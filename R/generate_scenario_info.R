
DEFAULT.SCENARIO.TYPE <- "Reference"

#' ScenarioInfo constructor
#'
#' Create a structure that ontains all information needed to describe a
#' scenario.
#'
#' Most of the parameters are self-explanatory.  The \code{Obsvar} parameter
#' is a little unusual, in that it plays no role in the model calculations; it
#' only enters into the likelihood function.  Fitting this parameter allows us
#' to estimate how much of the variation in the observed data isn't captured by
#' our model.  This variation could be because of irreducible uncertainty (e.g.,
#' measurement error in the observed data), or it could be an indicator that
#' there is some behavior that our model is failing to capture.
#'
#' @param aExpectationType Expectation type
#' @param aLaggedShareOld Share of old expectations included in current expectation
#' @param aLinearYears Years for linear expectations
#' @param aLogitUseDefault Boolean indicating whether to use default logits
#' @param aLogitAgroForest AgroForest logit exponent (assuming mLogitUseDefault == FALSE)
#' @param aLogitAgroForest_NonPasture AgroForest_NonPasture logit exponent (assuming mLogitUseDefault == FALSE)
#' @param aLogitCropland Cropland logit exponent (assuming mLogitUseDefault ==
#' FALSE)
#' @param aScenarioType Type of scenario to run: either "Reference" or "Hindcast".
#' @param aScenarioName Complete scenario name, with expectations & logit info
#' @param aFileName File name
#' @param aOutputDir Output directory
#' @param aSerialNum Serial number for a run that is part of a series.
#' @param aRegion Region to use in the calculation.  Right now we only run a
#' single region at a time.
#' @return New ScenarioInfo object
#' @export
#' @author KVC November 2017
ScenarioInfo <- function(# Currently only "Perfect", "Linear", and "Lagged" ExpectationType are supported
                         aExpectationType = NULL,
                         aLaggedShareOld = NA,
                         aLinearYears = NA,
                         aLogitUseDefault = TRUE,
                         aLogitAgroForest = NA,
                         aLogitAgroForest_NonPasture = NA,
                         aLogitCropland = NA,
                         aScenarioType = DEFAULT.SCENARIO.TYPE,
                         aScenarioName = NULL,
                         aFileName = NULL,
                         aOutputDir = "./outputs",
                         aSerialNum = NA,
                         aRegion = DEFAULT.REGION) {

  self <- new.env(parent=emptyenv())
  class(self) <- c("ScenarioInfo", class(self))

  self$mExpectationType <- aExpectationType
  self$mLaggedShareOld <- aLaggedShareOld
  self$mLinearYears <- aLinearYears
  self$mLogitUseDefault <- aLogitUseDefault
  self$mLogitAgroForest <- aLogitAgroForest
  self$mLogitAgroForest_NonPasture <- aLogitAgroForest_NonPasture
  self$mLogitCropland <- aLogitCropland
  self$mScenarioType <- aScenarioType
  self$mScenarioName <- aScenarioName
  self$mFileName <- aFileName
  self$mOutputDir <- aOutputDir
  self$mRegion <- aRegion
  self$mSerialNumber <- aSerialNum          # Used in run_ensemble
  self$mPointwiseLikelihood <- data.frame() # actually log-likelihood, tabulated
                                        # by data point.
  self$mLogPost <- data.frame()

  self
}


#' Test whether an object is a \code{ScenarioInfo} object
#'
#' @param object Object to be tested.
#' @export
is.ScenarioInfo <- function(object)
{
    inherits(object, 'ScenarioInfo')
}

#' Convert an object to a \code{ScenarioInfo} object
#'
#' @param object Object to be converted.
#' @export
as.ScenarioInfo <- function(object)
{
    UseMethod("as.ScenarioInfo", object)
}

#' @describeIn as.ScenarioInfo Convert an environment to a \code{ScenarioInfo}
#'
#' @export
as.ScenarioInfo.environment <- function(object)
{
    if(!is.ScenarioInfo(object)) {
        class(object) <- c('ScenarioInfo', class(object))
    }
    object
}

#' @describeIn as.ScenarioInfo Convert a list to a \code{ScenarioInfo}
#'
#' @export
as.ScenarioInfo.list <- function(object)
{
    eobj <- list2env(object, parent=emptyenv())
    as.ScenarioInfo(eobj)
}


#' SCENARIO.INFO
#'
#' A \code{ScenarioInfo} object with parameters for the default scenario.
#'
#' @export
#' @author Kate Calvin
SCENARIO.INFO <- ScenarioInfo(aScenarioType = DEFAULT.SCENARIO.TYPE,
                              aExpectationType = "Perfect",
                              aLinearYears = NA,
                              aLaggedShareOld = NA,
                              aLogitUseDefault = TRUE,
                              aLogitAgroForest = NA,
                              aLogitAgroForest_NonPasture = NA,
                              aLogitCropland = NA,
                              aScenarioName = paste0(DEFAULT.SCENARIO.TYPE, "_", "Perfect"),
                              aFileName = paste0(DEFAULT.SCENARIO.TYPE, "_", "Perfect"))
