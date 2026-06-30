
<!-- badges: start -->
[![R-CMD-check]()](
)
[![pkgdown]()](

)
[![Docker Build Status]()](
)
[![Deploy to DO]()](
)
[![Deployed App Status]()](
)
<!-- badges: end -->

# Global Biodiversity Information Facility (gbif) - app

`{gbif}` is an R package that
creates a [{shiny}](https://shiny.posit.co/) app that interfaces with the biodiversity data.  PostgreSQL database which contains energy density, proximate composition, stable isotope, thiamine, fatty acid, mercury and PCB data for fish and aquatic invertebrates throughout the Great Lakes and North America. The app provides a seamless and rich interface to interact with the database. 

 
The app can be accessed at [gbif.org](https://gbif.org/) and provides the ability to do the following: 


# Installation and Running the App
The `{gbif}` package can be installed in R using the following: 
``` r
pak::pak('benjaminhlina/gbif-app')
```

To run the app use the following: 
``` r
library(glatar)
glatar_app()
```
To view the overall progress of the package please see news.

# Repository Structure 

This repository contains a shiny app built as a package (i.e, `{gbif}`) along with Dockerfiles, `{renv}` files, a shell file, nginx and shiny-server configuration files, and a html file. 

The structure of the package is the following: 

``` r
├── R
│   ├── app_gbif.R
```

with `app_gbif.R` containing `gbif_app()` which builds the `ui`, `server` and runs `shiny::shinyApp(ui = ui, server = server)`. 

The `ui` contains a list of tabs, panels, and sidebars to build given the corresponding 
module functions. While `server` contains the appropriate server functions that map 
to a given `ui` (e.g., `""` tab in `ui` with the same shiny namespace name being used in the `server`).  

From there, there are `mod_*.R` and`fnct_*.R` files. 

`mod_*.R` files contain modules and modals that have `ui` and `server` functions that are directly used in either the `ui` or `server` within `glatar_app()`. 

``` r
├── R
```


Next, any `fnct_*.R` files have functions that are to be used in either other functions found in 
`fnct_*.R` files or directly in `mod_*.R` files. 

```r 

├── R
...
```

# Continuous Integration (CI) and Server Deployment 

The package and app are deployed using GitHub Actions (GHA). When a push to the 
main branch of the repository occurs or cron job runs, the first two actions to be triggered are [R CMD Check](). R CMD check, checks if the package can be built while pkgdown deploys the documentation to a pkgdown website. 

Upon the R CMD Check successfully completing, a GHA is triggered that [builds a docker container](). This container uses [rocker's shiny image](https://hub.docker.com/r/rocker/shiny) and installs all of the packages needed to support `{gbif}` using `{renv}` and `{pak}`, it then installs a fresh version of `{gbif}` and copies the `app.R` file in the main directory. This file contains the following: 
``` r
library(gbif)
gbif_app()
```

This will allow the shiny-server to run properly and executes the `shiny_entry.sh` file. This file contains environmental variables and excutes shiny-server. This docker container is registred on GitHub Container Registery (GHCR). 

Once complete, another [GHA]() is triggered which uses docker composer (i.e, `docker-compose.yaml`) to deploy the container with the shiny app, and an nginx and certbot containers on to a Digital Ocean's Droplet. 

Lastly, once that GHA is complete, a [GHA checks]() if the app returns a `200` status and if the logs run to confirm the app has been deployed properly. 

# Contribution and Issues Policy 
If you would like to contribute please feel free to fork the repository, create a branch, implement your changes, and submit a PR for review. 

This repository will not be accepting LLM submitted PRs nor PRs that contain directly copy and pasted code from LLMs that has not be vetted and edited. 

Issues that are submitted by LLMs and/or copied and pasted from LLMs will be deleted and ignored, as the issuer needs to have the ability to be able to write their own issues.
