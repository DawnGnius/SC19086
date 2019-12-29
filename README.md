* Edit the help file skeletons in 'man', possibly combining help files
  for multiple functions.
* Edit the exports in 'NAMESPACE', and add necessary imports.
* Put any C/C++/Fortran code in 'src'.
* If you have compiled code, add a useDynLib() directive to
  'NAMESPACE'.
* Run R CMD build to build the package tarball.
* Run R CMD check to check the package tarball.

Read "Writing R Extensions" for more information.

## Cpp files

1. directly put cpp files into the ./src florde. 

2. "Build" -- "install and restrat"

3. rcpp function is achievable after 'library()'.


## Vignettes Preparation and Development Cycle

This is a vignette rmarkdown file. 
> Reference: https://r-pkgs.org/vignettes.html

### To create your first vignette, run:

`usethis::use_vignette("my-vignette")`
This will:

1. Create a vignettes/ directory.

2. Add the necessary dependencies to DESCRIPTION (i.e. it adds knitr to the `Suggests` and `VignetteBuilder` fields).

3. Draft a vignette, `vignettes/my-vignette.Rmd`. 

### Create a package bundle with the vignettes included

There are 2 methods:

1. `devtools::build_vignettes()` Build all vignettes from the console.

2. `devtools::build()` Create a package bundle with the vignettes included.

Note that 
```
#> devtools::build()
#>Building the package will delete...
#>  'C:/Users/Gnius/Documents/Code/R/StatComp-R/inst/doc'
#>Are you sure?
```

Note that
RStudio’s `Build & reload` does not build vignettes to save time. 
Similarly, `devtools::install_github()` (and friends) will not build vignettes by default because they’re time consuming and may require additional packages. 
You can force building with `devtools::install_github(build_vignettes = TRUE)`. 
This will also install all suggested packages.

### Description

any packages used by the vignette must be declared in the DESCRIPTION


## Create a package
mainly use `devtools`

1. load all

2. check()

3. `man` floder (if need modify documents)

Create documents (.Rd files and NAMESPACE)

`devtools::document()`

See slides AR3_ page 4. 

4. vignette (if need modify)

See above. 

## Install and Use

```r
# install
library(devtools)
devtools::install_github("DawnGnius/StatComp19086")
# devtools::install_github("DawnGnius/StatComp19086", build_vignettes=TRUE)

# loads
library(StatComp19086)
# we can use it. 

# remove 
remove.packages("StatComp19086", lib="~/R/win-library/3.6")
```
