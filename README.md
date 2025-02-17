
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffsimulator <a href='#'><img src="man/figures/logo.png" align="right" width="25%" min-width="120px"/></a>

<!-- badges: start -->
<!-- [![CRAN status](https://img.shields.io/cran/v/ffsimulator?style=flat-square&logo=R&label=CRAN)](https://CRAN.R-project.org/package=ffsimulator)  -->

[![Dev
status](https://img.shields.io/github/r-package/v/dynastyprocess/ffsimulator/main?label=dev%20version&style=flat-square&logo=github)](https://ffsimulator.dynastyprocess.com/)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=flat-square)](https://lifecycle.r-lib.org/articles/stages.html)
[![R build
status](https://img.shields.io/github/workflow/status/dynastyprocess/ffsimulator/R-CMD-check?label=R%20check&style=flat-square&logo=github)](https://github.com/DynastyProcess/ffsimulator/actions)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/dynastyprocess/ffsimulator?label=codecov&style=flat-square&logo=codecov)](https://codecov.io/gh/DynastyProcess/ffsimulator?branch=main)
[![nflverse
discord](https://img.shields.io/discord/591914197219016707.svg?color=5865F2&label=nflverse%20discord&logo=discord&logoColor=5865F2&style=flat-square)](https://discord.com/invite/5Er2FBnnQa)

<!-- badges: end -->

The `{ffsimulator}` package helps simulate fantasy football seasons. By
leveraging historical weekly finishes, current expert consensus
rankings, and your league’s data, this package can quickly run your
league through hundreds of seasons and may help you study:

-   expected season finishes and range of outcomes
-   player contributions to season wins
-   effects of potential trades
-   and more!

This package is part of the [ffverse](https://ffverse.com) family of R
packages for fantasy football analysis.

## Installation

Install the stable version of this package from the [ffverse r-universe
repository](https://ffverse.r-universe.dev):

``` r
install.packages("ffsimulator", repos = "https://ffverse.r-universe.dev")
```

Install the development version with either [DynastyProcess’s
r-universe](https://dynastyprocess.r-universe.dev) or remotes + GitHub:

``` r
# ffverse's r-universe
install.packages("ffsimulator", repos = "https://dynastyprocess.r-universe.dev")

# or via GitHub c/o remotes/devtools: # install.packages('remotes')
remotes::install_github("dynastyprocess/ffsimulator")
```

The dev version has a [separate documentation site
here](https://ffsimulator.ffverse.com/dev/).

## Roadmap

-   Create logic in ADP outcomes to bin together nearby ranks (nearest
    one above/below) :white\_check\_mark: *(binning +1 and -1 together)*
-   Scrape more historical ranks to include in package so that we can
    use 2010-2020 :white\_check\_mark: *(2012-2020 is close enough!)*
-   Patch data inconsistency for IDs (2012:2015)
-   Create join functions for each of the remaining ff\_connect classes
    :white\_check\_mark:
-   Create summary function (season-level H2H wins/winpct, AP
    wins/winpct, total PF + PP) :white\_check\_mark:
-   Create simulation summary table :white\_check\_mark:
-   Write function documentation :white\_check\_mark:
-   Write tests :white\_check\_mark:
-   Add test cache infrastructure
-   Write basic usage vignette
-   Write custom usage vignette
-   Add autoplot
-   Clean up README
-   CRAN prep

## Usage

This package shares many conventions with the ffverse, including all
main functions being prefixed with `ff_` for ease of autocomplete.

``` r
library(ffsimulate)

conn <- mfl_connect(2021,22627)

sims <- ff_simulate(conn, n_seasons = 100, weeks_per_season = 14, best_ball = FALSE)

sims$summary
```

Please also see the [basic
usage](https://ffsimulator.ffverse.com/articles/basic.html) and [manual
simulation](https://ffsimulator.ffverse.com/articles/manual.html)
vignettes for a detailed introduction.

## Getting help

The best places to get help on this package are:

-   the [nflverse discord](https://discord.com/invite/5Er2FBnnQa) (for
    both this package as well as anything R/NFL related)
-   opening [an
    issue](https://github.com/dynastyprocess/ffsimulator/issues/new/choose)

## Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

-   You can [open an
    issue](https://github.com/dynastyprocess/ffsimulator/issues/new/choose)
    if you’d like to request specific data or report a bug/error.

-   You can [sponsor this project with
    donations](https://github.com/sponsors/tanho63)!

-   If you’d like to contribute code, please check out [the contribution
    guidelines](https://ffsimulator.ffverse.com/CONTRIBUTING.html).

## Terms of Use

The R code for this package is released as open source under the [MIT
License](https://ffsimulator.ffverse.com/LICENSE.html).

Fantasy football and NFL data accessed by this package belong to their
respective owners, and are governed by their terms of use.
