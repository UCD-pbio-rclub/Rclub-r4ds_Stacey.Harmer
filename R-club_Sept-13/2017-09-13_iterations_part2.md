# R Notebook
Section 21: part 4 - end



# 21.4

```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}
output
```

```
## [1] -0.1319787  0.1974806  0.1204580 -0.2192252
```

make that a function


```r
col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}

col_mean(df)
```

```
## [1] -0.1319787  0.1974806  0.1204580 -0.2192252
```

but, we can pass one function to another!  

```r
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}
col_summary(df, median)
```

```
## [1] -0.2469423  0.1029053  0.2076122 -0.4198061
```

```r
col_summary(df, sum)
```

```
## [1] -1.319787  1.974806  1.204580 -2.192252
```

##21.4.1 Exercises

1.  Read the help file for apply().  In the 2d case, what two for loops does it generate?

I have no idea what the 2d case means. 

2.  Adapt col_summary() so that it only applies to numeric columns 

```r
#  start with an is_numeric() function that returns a logical vector that has a TRUE corresponding to each numeric column.

col_summary2 <- function(df, fun) {
  # test whether each colum is numeric
  numeric_cols <- vector("logical", length(df))
  for (i in seq_along(df)) {
    numeric_cols[[i]] <- is.numeric(df[[i]])
  }
  # indexes of numeric columns
  idxs <- seq_along(df)[numeric_cols]
  # number of numeric columns
  n <- sum(numeric_cols)
  out <- vector("double", n)
  for (i in idxs) {
    out[i] <- fun(df[[i]])
  }
  out
}

# whoa, that was complicated

col_summary_rev <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}
```

# 21.5  The map functions


```r
map_dbl(df, mean)
```

```
##          a          b          c          d 
## -0.1319787  0.1974806  0.1204580 -0.2192252
```

```r
map_dbl(df, median)
```

```
##          a          b          c          d 
## -0.2469423  0.1029053  0.2076122 -0.4198061
```

An even more transparent method:

```r
df %>% map_dbl(mean)
```

```
##          a          b          c          d 
## -0.1319787  0.1974806  0.1204580 -0.2192252
```

## 21.5.1  Shortcuts


```r
models <- mtcars %>% 
  split(.$cyl) %>%  # that is handy! 
  map(function(df) lm(mpg ~ wt, data = df))

# or

models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))
```

 now extract summary
 

```r
models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)
```

```
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
```

```r
# or more concisely
models %>% 
  map(summary) %>% 
  map_dbl("r.squared")
```

```
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
```

#  21.5.2  Base R


```r
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06), 
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)
x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78), 
  c(0.93, 0.21, 0.65, 0.13, 0.27), 
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
```

```
## List of 3
##  $ : num 0.91
##  $ : num [1:2] 0.9 0.94
##  $ : num(0)
```

```r
x2 %>% sapply(threshold) %>% str()
```

```
##  num [1:3] 0.99 0.93 0.87
```

## 21.5.3  MAP function exercises

1.  Write code that uses one of the map functions to:

1. Compute the mean of every column in mtcars.


```r
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

```r
map_dbl(mtcars, mean) # easy!
```

```
##        mpg        cyl       disp         hp       drat         wt 
##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250 
##       qsec         vs         am       gear       carb 
##  17.848750   0.437500   0.406250   3.687500   2.812500
```

2. Determine the type of each column in nycflights13::flights.

```r
head(nycflights13::flights)
```

```
## # A tibble: 6 × 19
##    year month   day dep_time sched_dep_time dep_delay arr_time
##   <int> <int> <int>    <int>          <int>     <dbl>    <int>
## 1  2013     1     1      517            515         2      830
## 2  2013     1     1      533            529         4      850
## 3  2013     1     1      542            540         2      923
## 4  2013     1     1      544            545        -1     1004
## 5  2013     1     1      554            600        -6      812
## 6  2013     1     1      554            558        -4      740
## # ... with 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>,
## #   time_hour <dttm>
```

```r
map_chr(nycflights13::flights, typeof)
```

```
##           year          month            day       dep_time sched_dep_time 
##      "integer"      "integer"      "integer"      "integer"      "integer" 
##      dep_delay       arr_time sched_arr_time      arr_delay        carrier 
##       "double"      "integer"      "integer"       "double"    "character" 
##         flight        tailnum         origin           dest       air_time 
##      "integer"    "character"    "character"    "character"       "double" 
##       distance           hour         minute      time_hour 
##       "double"       "double"       "double"       "double"
```
doesn't get the datetime right for last column

```r
map(nycflights13::flights, class)
```

```
## $year
## [1] "integer"
## 
## $month
## [1] "integer"
## 
## $day
## [1] "integer"
## 
## $dep_time
## [1] "integer"
## 
## $sched_dep_time
## [1] "integer"
## 
## $dep_delay
## [1] "numeric"
## 
## $arr_time
## [1] "integer"
## 
## $sched_arr_time
## [1] "integer"
## 
## $arr_delay
## [1] "numeric"
## 
## $carrier
## [1] "character"
## 
## $flight
## [1] "integer"
## 
## $tailnum
## [1] "character"
## 
## $origin
## [1] "character"
## 
## $dest
## [1] "character"
## 
## $air_time
## [1] "numeric"
## 
## $distance
## [1] "numeric"
## 
## $hour
## [1] "numeric"
## 
## $minute
## [1] "numeric"
## 
## $time_hour
## [1] "POSIXct" "POSIXt"
```

```r
# this gives list of differnet types
```

3. Compute the number of unique values in each column of iris.

```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
map_dbl(iris, length(unique()))
```

```
## Error in is.factor(x): argument "x" is missing, with no default
```


4. Generate 10 random normals for each of   μ = -10, 0, 10, and 100


