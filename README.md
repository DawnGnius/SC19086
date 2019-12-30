# Summary on writting R package

> Read "Writing R Extensions" for more information.
>
> Read [R Packages](r-pkgs.org) for details.

## Build a package

1. load all

    use `devtools::load_all()` in R console.

2. check()

   use `devtools::check()` in R console.

3. Edit `man` floder (if modification is needed)

    1. Edit your `r` or `cpp` file correctly.

    > See slides AR3_.pdf page 4.

    1. using `devtools::document()`

    > This will create documents in `man` .Rd files and create NAMESPACE file.
    >
    > Before use `document()`, you should delete NAMESPACE.

4. Edit `vignettes` floder (if modification is needed)

    > See above.

## Install and Use

```r
# install from remote
devtools::install_github("DawnGnius/SC19086", build_vignettes=TRUE)
# using `build_vignettes`, we can force installing package with vignettes.

# install from local
devtools::install(".", build_vignettes=TRUE)
# using `build_vignettes`, we can force installing package with vignettes.

# load this package
library(SC19086)

# remove from your lib
remove.packages("SC19086", lib="~/R/win-library/3.6")
```

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
#>  'C:/Users/Gnius/Documents/Code/R/SC-R/inst/doc'
#>Are you sure?
```

Note that
RStudio’s `Build & reload` does not build vignettes to save time. 
Similarly, `devtools::install_github()` (and friends) will not build vignettes by default because they’re time consuming and may require additional packages. 
You can force building with `devtools::install_github(build_vignettes = TRUE)`. 
This will also install all suggested packages.

## Bugs

1. cpp function cannot be called, after installing from local.

    > add `@useDynLib SC19086, .registration = TRUE` into cpp files befor `@export` line
    >
    > add `@importFrom Rcpp evalCpp` into any one cpp file
    >
    > add `@exportPattern "^[[:alpha:]]+"` into any one cpp file
    >
    > add `Encoding: UTF-8` into DESCRIPTION
    >
    > `devtools::document()` will auto create/update .Rd files in `man` floder and also `NAMESPACE`
    >
    >> Please, Check `Rcpp::Rcpp.package.skeleton()` for detials.

2. Rename your R package and your R project

This is a strange request, but we may occure it. We should change all filename firstly. 

Then we need to focuce on file contents
    1. DESCRIPTION
    2. `src`, `R`, `man` floder are important. Something we can change by hand, something cannot.
    3. Notice: `@useDynLib SC19086, .registration = TRUE`, please change `NAMESPACE` by hand before `devtools::document()`
    4. Use `findstr /s /i "StatComp19086.DLL" *.*` to deal with the most difficult thing. And then, everything works well.

3. Cannot find function after installing.
    
    Check `NAMESPACE` export function. If not exist, document() again.

4. Cannot install my package in other computers.

    Add dependencies into `DESCRIPTION`, it's not auto.

5. Cannot instal my package in other computers [build vignettes error]

    Add dependencies into `Imports` rather than `Suggests` in `DESCRIPTION` file.
    > [dependencies auto install pkgs in "Depends", "Imports", "LinkingTo"](https://stackoverflow.com/questions/14171148/how-to-tell-cran-to-install-package-dependencies-automatically)
