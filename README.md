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

## Install and Use

```r
# install
library(devtools)
devtools::install_github("DawnGnius/StatComp19086")
# devtools::install_github("DawnGnius/StatComp19086", build_vignettes=TRUE)

# load
library(StatComp19086)
# we can use it. 

# remove 
remove.packages("StatComp19086", lib="~/R/win-library/3.6")
```
