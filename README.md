
<!-- badges: start -->
[![R CMD check](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/R_CMD_check.yaml/badge.svg)](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/R_CMD_check.yaml)
[![Deploy Docker Compose to DO](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/deploy_to_do.yaml/badge.svg)](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/deploy_to_do.yaml)
[![Deployed App Status]()]

<!-- badges: end -->

# Global Biodiversity Information Facility (gbif) - app

`{gbif}` is an R package that
creates a [{shiny}](https://shiny.posit.co/) app that interfaces with the biodiversity data. Global Biodiversity Information Facility observation data is stored in a DuckDB database with the app provides a seamless and rich interface to interact with the observation data. 

 
The app can be accessed at [gbif.glatar.org](https://gbif.glatar.org/) and provides the ability to do the following: 

1. Use an interactive map that displays observational data. 
    a. This data can be viewed by selecting a single or mulitple countries. 
    b. If a user would like to search for a specific species they can filter the data using the Search Taxa box. 
    c. There is also the ability to filter the data by the observation date and time using the slider below the interactive map. 
    d. The observations are ploted with large size and brighter points indicating more observations of species. 
    e. If a user selects a point a suite of information about the species that was observed appears, including a link, if available, to a photo 
    of the speices 


# Installation and Running the App
The `{gbif}` package can be installed in R using the following: 
``` r
pak::pak('benjaminhlina/biodiversity-app')
```

To run the app use the following: 
``` r
library(gbifapp)
gbif_app()
```

# Repository Structure 

This repository contains a shiny app built as a package (i.e, `{gbif}`) along with Dockerfiles, `{renv}` files, a shell file, nginx and shiny-server configuration files,

The structure of the package is the following: 

``` r
├── R
│   ├── app_gbif.R
```

with `app_gbif.R` containing `gbif_app()` which builds the `ui`, `server` and runs `shiny::shinyApp(ui = ui, server = server)`. 

The `ui` contains a list of tabs, panels, and sidebars to build given the corresponding 
module functions. While `server` contains the appropriate server functions that map 
to a given `ui` (e.g., `"home"` tab in `ui` with the same shiny namespace name being used in the `server`).  

From there, there are `mod_*.R` and`fnct_*.R` files. 

`mod_*.R` files contain modules and modals that have `ui` and `server` functions that are directly used in either the `ui` or `server` within `gbif_app()`. 

``` r
├── R
├── ├── mod_home_tab.R
```


Next, any `fnct_*.R` files have functions that are to be used in either other functions found in 
`fnct_*.R` files or directly in `mod_*.R` files. 

```r 

├── R
├── ├── fnct_get.R
```

# Continuous Integration (CI) and Server Deployment 

The package and app are deployed using GitHub Actions (GHA). When a push to the 
main branch of the repository occurs or cron job runs, the first two actions to be triggered are [R CMD Check](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/R_CMD_check.yaml). R CMD check, checks if the package can be built and once successfully completed, a GHA is triggered that [builds a docker container](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/R_CMD_check.yaml). This container uses [rocker's shiny image](https://hub.docker.com/r/rocker/shiny) and installs all of the packages needed to support `{gbifapp}` using `{renv}` and `{pak}`, it then installs a fresh version of `{gbifapp}` and copies the `app.R` file in the main directory. This file contains the following: 
``` r
library(gbifapp)
gbif_app()
```

This will allow the shiny-server to run properly and executes the `shiny_entry.sh` file. This file contains environmental variables and excutes shiny-server. This docker container is registred on GitHub Container Registery (GHCR). 

Once complete, another [GHA](https://github.com/benjaminhlina/biodiversity-app/actions/workflows/deploy_to_do.yaml) is triggered which uses docker composer (i.e, `docker-compose.yaml`) to deploy the container with the shiny app, and an nginx and certbot containers on to a Digital Ocean's Droplet. 

Lastly, once that GHA is complete, a [GHA checks]() if the app returns a `200` status and if the logs run to confirm the app has been deployed properly. 

# Contribution and Issues Policy 
If you would like to contribute please feel free to fork the repository, create a branch, implement your changes, and submit a PR for review. 

This repository will not be accepting LLM submitted PRs nor PRs that contain directly copy and pasted code from LLMs that has not be vetted and edited. 

Issues that are submitted by LLMs and/or copied and pasted from LLMs will be deleted and ignored, as the issuer needs to have the ability to be able to write their own issues.
