# 2017-08-23_functions.Rmd
Stacey Harmer  
8/21/2017  



## Assigment: 
Rest of Chapter 19 (19.5 - 19.7)
Chatpter 20.1 - 20.3 including exercises 20.3.5

how to knit with an error in the code
  chunk:  {r, error = TRUE} in the header

## 19.5

```r
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
```

```
## [1] 0.4247420 0.5295919
```

```r
#> [1] 0.498 0.610
mean_ci(x, conf = 0.99)
```

```
## [1] 0.4082689 0.5460651
```

```r
#> [1] 0.480 0.628
```

note that commonly, n = number of rows and p = number of columns

### 19.5.2


```r
library(tidyverse)
```

```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```

```r
library(stringr)

wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w * x) / sum(w)
}

wt_mean(1:8, 2:9) # ok
```

```
## [1] 5.454545
```

```r
wt_mean(1:4, 2:9) # Ok
```

```
## Error: `x` and `w` must be the same length
```

```r
# or instead

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }   # I don't follow this part
  sum(w * x) / sum(w)
}
wt_mean(1:6, 6:1, na.rm = "foo")
```

```
## Error: is.logical(na.rm) is not TRUE
```

```r
#> Error: is.logical(na.rm) is not TRUE
wt_mean(1:6, 6:1)
```

```
## [1] 2.666667
```

```r
wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))

  sum(w * x) / sum(w)
}
wt_mean(1:6, 6:1)
```

```
## [1] 2.666667
```

### 19.5.3


```r
commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])
```

```
## [1] "a, b, c, d, e, f, g, h, i, j"
```

```r
#> [1] "a, b, c, d, e, f, g, h, i, j"

rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")
```

```
## Important output ------------------------------------------------------
```

```r
#> Important output ------------------------------------------------------
```

### 19.5.5 Exercises

### 1. What does commas(letters, collapse = "-") do? Why?

```r
commas(letters[1:10], collapse = "-")
```

```
## Error in stringr::str_c(..., collapse = ", "): formal argument "collapse" matched by multiple actual arguments
```

```r
# Error in stringr::str_c(..., collapse = ", ") : 
```
This generates an error.


```r
stringr::str_c(letters[1:10], collapse = ", ") # this does not generate an error
```

```
## [1] "a, b, c, d, e, f, g, h, i, j"
```

```r
stringr::str_c(letters[1:10], collapse = "-")  # nor does this
```

```
## [1] "a-b-c-d-e-f-g-h-i-j"
```

```r
commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10]) # no error
```

```
## [1] "a, b, c, d, e, f, g, h, i, j"
```

```r
commas(letters[1:10], collapse = ", ") # error
```

```
## Error in stringr::str_c(..., collapse = ", "): formal argument "collapse" matched by multiple actual arguments
```

Why is it differnet when collapse called within a function vs outside of it?
Because when runnign the function, it thinks collapse ", " should itself be collapsed.
(interprets is as part of  . . . )

### 2 It’d be nice if you could supply multiple characters to the pad argument, e.g. rule("Title", pad = "-+"). Why doesn’t this currently work? How could you fix it?


```r
# this works
rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")
```

```
## Important output ------------------------------------------------------
```

```r
rule <- function(..., pad = "-+") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")  # this kind of works, but it is 2x too long
```

```
## Important output -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

```r
 # so halve the width
rule <- function(..., pad = "-+") {
  title <- paste0(...)
  width <- getOption("width")/2 - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output") 
```

```
## Important output -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

```r
# or more generally
rule <- function(..., pad = "-!-") {
  title <- paste0(...)
  width <- getOption("width")/nchar(pad) - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output") 
```

```
## Important output -!--!--!--!-
```

### 3 What does the trim argument to mean() do? When might you use it?

I wondered about this

```r
?mean
```

trim is the fraction (0 to 0.5 ) of observations to be trimmed frm each end of x before mean is computed.  
I might use if I thought my data had outliers that should be removed.

### 4 The default value for the method argument to cor() is c("pearson", "kendall", "spearman"). What does that mean? What value is used by default?

These are different correlation methods. Help suggests pearson is default for cor()


```r
cor(c(1:10, 55, 77), c(2:11, 150, 999), method = "pearson") # 0.8779594
```

```
## [1] 0.8779594
```

```r
cor(c(1:10, 55, 77), c(2:11, 150, 999), method = "kendall") # 1
```

```
## [1] 1
```

```r
cor(c(1:10, 55, 77), c(2:11, 150, 999), method = "spearman")  # 1
```

```
## [1] 1
```

```r
cor(c(1:10, 55, 77), c(2:11, 150, 999)) # 0.8779594
```

```
## [1] 0.8779594
```
So yes, Pearson is default method for cor()

## 19.6 

Use of return within function can be useful


```r
complicated_function <- function(x, y, z) {
  if (length(x) == 0 || length(y) == 0) {
    return(0)
  }
    
  # Complicated code here
}
#### WHAT does the || mean here?

x <- numeric(0) # empty vector
y <- c(11:20)
length(x) == 0 || length(y) == 0  # true
```

```
## [1] TRUE
```

```r
length(x) == 0 | length(y) == 0  # also true
```

```
## [1] TRUE
```

pipeable functions


```r
show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}
show_missings(mtcars)
```

```
## Missing values: 0
```

```r
x <- show_missings(mtcars) 
```

```
## Missing values: 0
```

```r
#> Missing values: 0
class(x)
```

```
## [1] "data.frame"
```

```r
#> [1] "data.frame"
dim(x)
```

```
## [1] 32 11
```

```r
mtcars %>% 
  show_missings() %>% 
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings()
```

```
## Missing values: 0
## Missing values: 18
```

That is clever

## 19.7  Environments

# 20.  Vectors

```r
library(tidyverse)
```

## 20.2  VEctor basics

Null typically behaves like a vector of length 0
what are complex and raw atomic vectors? He later says they are rarely used during data analysis

```r
y <- NULL
y
```

```
## NULL
```

```r
length(y) == 0
```

```
## [1] TRUE
```

## 20.3  types of atomic vectors 
Logical:  T, F, and NA

Numeric: doubles (default) or integers.  
note that doubles are approximations


```r
x <- sqrt(2) ^ 2
x
```

```
## [1] 2
```

```r
x - 2
```

```
## [1] 4.440892e-16
```

```r
x <- sqrt(2L) ^ 2L
x
```

```
## [1] 2
```

```r
x - 2  # WHY isn't this now exactly 0??
```

```
## [1] 4.440892e-16
```

```r
x == 2 # FALSE
```

```
## [1] FALSE
```

```r
x <- 2
x == 2 # TRUE (?)
```

```
## [1] TRUE
```

```r
x - 2 #0.  huh
```

```
## [1] 0
```

```r
x - 2 == 0 # TRUE
```

```
## [1] TRUE
```

```r
# I'm confused by the above
```

Integers can be NA; doubles can be NA, NaN, Inf, or -Inf

Remember functions is.finite(), is.infinite(), and is.nan


```r
is.infinite(-Inf) # TRUE
```

```
## [1] TRUE
```

### 20.3.5  Exercises

### 1 Describe the difference between is.finite(x) and !is.infinite(x).


```r
x <- Inf

is.finite(x) # FALSE
```

```
## [1] FALSE
```

```r
!is.infinite(x) # FALSE
```

```
## [1] FALSE
```

```r
x <- c(Inf, 4, 5, 22, -Inf, NA)
is.finite(x) # NA listed as not finite
```

```
## [1] FALSE  TRUE  TRUE  TRUE FALSE FALSE
```

```r
!is.infinite(x) # NA classified as not infinite
```

```
## [1] FALSE  TRUE  TRUE  TRUE FALSE  TRUE
```

### 2 Read the source code for dplyr::near() (Hint: to see the source code, drop the ()). How does it work?


```r
dplyr::near
```

```
## function (x, y, tol = .Machine$double.eps^0.5) 
## {
##     abs(x - y) < tol
## }
## <environment: namespace:dplyr>
```
function (x, y, tol = .Machine$double.eps^0.5) 
{
    abs(x - y) < tol
}
<environment: namespace:dplyr>

It takes the squareroot of something called .Machine$double.eps

```r
?.Machine
```

double.eps	
the smallest positive floating-point number x

And if the absolute value of x -y is less than this, it calls a TRUE

### 3 A logical vector can take 3 possible values. How many possible values can an integer vector take? How many possible values can a double take? Use google to do some research.

Logical:  T, F, NA

help files tell me:
integers:
Note that current implementations of R use 32-bit integers for integer vectors, so the range of representable integers is restricted to about +/-2*10^9: doubles can hold much larger integers exactly.
So that is about 2 billion integers

double:
All R platforms are required to work with values conforming to the IEC 60559 (also known as IEEE 754) standard. This basically works with a precision of 53 bits, and represents to that precision a range of absolute values from about 2e-308 to 2e+308

But that doesn't tell me the number of possible values. 

another google tells me "On a typical R platform the smallest positive double is about 5e-324"

Wikipedia search on double-precision floating-point format
Double has from 15 to 17 significant decimal digits.  

I wasn't able to really answer this correctly.

### 4  Brainstorm at least four functions that allow you to convert a double to an integer. How do they differ? Be precise.


```r
# FIRST function
x <- 3
typeof(x) # double
```

```
## [1] "double"
```

```r
x <- as.integer(x)
typeof(x) # integer
```

```
## [1] "integer"
```

```r
x <- c(3, 5, 11)
typeof(x) # double
```

```
## [1] "double"
```

```r
make.int <- function(x){
  as.integer(x)
}

typeof(make.int(x))
```

```
## [1] "integer"
```


And then some failed attempts:


```r
# SECOND function
x <- c(3, 5, 11)
typeof(x) # double
```

```
## [1] "double"
```

```r
typeof(paste(x, "L", sep ="")) # character.  dang it, doesn't work
```

```
## [1] "character"
```


```r
# rounding?

x <- 3.9
typeof(x)
```

```
## [1] "double"
```

```r
x <- ceiling(x)
typeof(x) # double, not integer
```

```
## [1] "double"
```

```r
typeof(round(x)) # still double, but it seems like it should work
```

```
## [1] "double"
```

```r
round(x, digits = 0)
```

```
## [1] 4
```

```r
y <- round(x, digits = 0)
typeof(y) # double.  weird
```

```
## [1] "double"
```

### 5 What functions from the readr package allow you to turn a string into logical, integer, and double vector?


```r
# some examples from the readr help page

mtcars <- read_csv(readr_example("mtcars.csv"))
```

```
## Parsed with column specification:
## cols(
##   mpg = col_double(),
##   cyl = col_integer(),
##   disp = col_double(),
##   hp = col_integer(),
##   drat = col_double(),
##   wt = col_double(),
##   qsec = col_double(),
##   vs = col_integer(),
##   am = col_integer(),
##   gear = col_integer(),
##   carb = col_integer()
## )
```

```r
summary(mtcars)
```

```
##       mpg             cyl             disp             hp       
##  Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0  
##  1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5  
##  Median :19.20   Median :6.000   Median :196.3   Median :123.0  
##  Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7  
##  3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0  
##  Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0  
##       drat             wt             qsec             vs        
##  Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000  
##  1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000  
##  Median :3.695   Median :3.325   Median :17.71   Median :0.0000  
##  Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375  
##  3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000  
##  Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000  
##        am              gear            carb      
##  Min.   :0.0000   Min.   :3.000   Min.   :1.000  
##  1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000  
##  Median :0.0000   Median :4.000   Median :2.000  
##  Mean   :0.4062   Mean   :3.688   Mean   :2.812  
##  3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000  
##  Max.   :1.0000   Max.   :5.000   Max.   :8.000
```

```r
# but what if I want to specify what is what?

mtcars <- read_csv(readr_example("mtcars.csv"), col_types = 
  cols(
    mpg = col_integer(),
    cyl = col_integer(),
    disp = col_double(),
    hp = col_integer(),
    drat = col_double(),
    vs = col_integer(), 
    wt = col_double(),  
    qsec = col_double(),
    am = col_integer(),
    gear = col_integer(),
    carb = col_integer()
  )
)
```

```
## Warning: 28 parsing failures.
## row col               expected actual                                                                                      file
##   3 mpg no trailing characters     .8 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/mtcars.csv'
##   4 mpg no trailing characters     .4 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/mtcars.csv'
##   5 mpg no trailing characters     .7 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/mtcars.csv'
##   6 mpg no trailing characters     .1 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/mtcars.csv'
##   7 mpg no trailing characters     .3 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/mtcars.csv'
## ... ... ...................... ...... .........................................................................................
## See problems(...) for more details.
```

```r
# didn't like that
summary(mtcars)
```

```
##       mpg             cyl             disp             hp       
##  Min.   :15.00   Min.   :4.000   Min.   : 71.1   Min.   : 52.0  
##  1st Qu.:19.50   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5  
##  Median :21.00   Median :6.000   Median :196.3   Median :123.0  
##  Mean   :20.75   Mean   :6.188   Mean   :230.7   Mean   :146.7  
##  3rd Qu.:22.25   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0  
##  Max.   :26.00   Max.   :8.000   Max.   :472.0   Max.   :335.0  
##  NA's   :28                                                     
##       drat             wt             qsec             vs        
##  Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000  
##  1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000  
##  Median :3.695   Median :3.325   Median :17.71   Median :0.0000  
##  Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375  
##  3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000  
##  Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000  
##                                                                  
##        am              gear            carb      
##  Min.   :0.0000   Min.   :3.000   Min.   :1.000  
##  1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000  
##  Median :0.0000   Median :4.000   Median :2.000  
##  Mean   :0.4062   Mean   :3.688   Mean   :2.812  
##  3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000  
##  Max.   :1.0000   Max.   :5.000   Max.   :8.000  
## 
```

```r
?col_logical
```

col_logical()

col_integer()

col_double()

col_character()
These functions prase the values as they are read in

The parse_logical, etc, functions deal with a character vector


```r
mtcars <- read_csv(readr_example("mtcars.csv"))
```

```
## Parsed with column specification:
## cols(
##   mpg = col_double(),
##   cyl = col_integer(),
##   disp = col_double(),
##   hp = col_integer(),
##   drat = col_double(),
##   wt = col_double(),
##   qsec = col_double(),
##   vs = col_integer(),
##   am = col_integer(),
##   gear = col_integer(),
##   carb = col_integer()
## )
```

```r
typeof(mtcars$mpg) # double
```

```
## [1] "double"
```

```r
typeof(parse_integer(mtcars$mpg)) # integer
```

```
## Warning: 28 parsing failures.
## row col               expected actual
##   3  -- no trailing characters     .8
##   4  -- no trailing characters     .4
##   5  -- no trailing characters     .7
##   6  -- no trailing characters     .1
##   7  -- no trailing characters     .3
## ... ... ...................... ......
## See problems(...) for more details.
```

```
## [1] "integer"
```


