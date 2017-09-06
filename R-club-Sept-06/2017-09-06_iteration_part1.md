# 2017-09-06_iteration_part1.Rmd
Stacey Harmer  
9/6/2017  

Ch 21 (for loops/iteration) through 21.4



Imperative programming = for loops, and while loops
functional programming = each common for loop gets its own function

## 21.2  For loops


```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
```

```
## # A tibble: 10 × 4
##              a           b          c           d
##          <dbl>       <dbl>      <dbl>       <dbl>
## 1  -0.89120873 -0.48695165  1.5111914 -0.84379906
## 2  -0.78884542 -0.40795248  0.1266682  0.06370502
## 3   0.28744098  0.08283191  0.5155719 -1.05660428
## 4   0.48730274 -0.75757572 -0.9015262 -0.90579139
## 5  -0.66249906 -1.50218807  1.1772229 -1.15687352
## 6   1.13930297  0.55223256  1.1028262 -0.17414862
## 7  -1.78819873  0.88697623 -1.5544660  1.23792424
## 8   0.36282446 -1.90771693  1.3222258 -0.63280546
## 9  -0.69662737 -1.48315391 -0.3964435 -0.71123216
## 10  0.07763503 -1.70456560  0.6141217  0.03709232
```

```r
output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
```

```
## [1] -0.2924320 -0.6222637  0.5648468 -0.6720188
```

```r
## WHY does seq_along count columns??  

output <- vector()  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
```

```
## [1] -0.2924320 -0.6222637  0.5648468 -0.6720188
```

## 21.2.1  For loop exercises

### 1. Write for loops to:

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
mtcars.means <- vector("double", ncol(mtcars))  
     for (i in seq_along(mtcars)) {            
     mtcars.means[[i]] <- mean(mtcars[[i]])      
   }
mtcars.means
```

```
##  [1]  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250
##  [7]  17.848750   0.437500   0.406250   3.687500   2.812500
```

```r
output <- vector("double", ncol(mtcars))
names(output) <- names(mtcars) # nice touch
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
flight.types <- vector("character", ncol(nycflights13::flights))
for (i in seq_along(nycflights13::flights)) {
  flight.types[[i]] <- typeof(nycflights13::flights[[i]])
}

flight.types
```

```
##  [1] "integer"   "integer"   "integer"   "integer"   "integer"  
##  [6] "double"    "integer"   "integer"   "double"    "character"
## [11] "integer"   "character" "character" "character" "double"   
## [16] "double"    "double"    "double"    "double"
```

```r
# I see that the last column was 'dttm' in the tibble but is 'double' when using typeof()

flight.types <- vector("list", ncol(nycflights13::flights))
for (i in seq_along(nycflights13::flights)) {
  flight.types[[i]] <- class(nycflights13::flights[[i]])
}

flight.types # this returned a date time for the last value
```

```
## [[1]]
## [1] "integer"
## 
## [[2]]
## [1] "integer"
## 
## [[3]]
## [1] "integer"
## 
## [[4]]
## [1] "integer"
## 
## [[5]]
## [1] "integer"
## 
## [[6]]
## [1] "numeric"
## 
## [[7]]
## [1] "integer"
## 
## [[8]]
## [1] "integer"
## 
## [[9]]
## [1] "numeric"
## 
## [[10]]
## [1] "character"
## 
## [[11]]
## [1] "integer"
## 
## [[12]]
## [1] "character"
## 
## [[13]]
## [1] "character"
## 
## [[14]]
## [1] "character"
## 
## [[15]]
## [1] "numeric"
## 
## [[16]]
## [1] "numeric"
## 
## [[17]]
## [1] "numeric"
## 
## [[18]]
## [1] "numeric"
## 
## [[19]]
## [1] "POSIXct" "POSIXt"
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
summary(iris)
```

```
##   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
##  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
##  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
##  Median :5.800   Median :3.000   Median :4.350   Median :1.300  
##  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
##  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
##  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
##        Species  
##  setosa    :50  
##  versicolor:50  
##  virginica :50  
##                 
##                 
## 
```

```r
# I think I need to use unique and length.  Try it:

length(unique(iris$Species)) # yep
```

```
## [1] 3
```

```r
unique.iris <- vector("double", ncol(iris))
for (i in seq_along(iris)) {
  unique.iris[[i]] <- length(unique(iris[[i]]))
}
unique.iris
```

```
## [1] 35 23 43 22  3
```

4.  Generate 10 random normals for each of  
μ = -10, 0, 10, and 100


```r
mu <- c(-10, 0, 10, 100)
rnorm(10, -10)
```

```
##  [1]  -8.891553 -11.244543 -10.200584 -12.214919 -10.625208 -10.424766
##  [7] -10.674156 -10.073152  -6.958763  -7.530727
```

```r
# I think I'd like a dataframe rather than a vector, but will work with vector here

mu.ran.norm <- vector("double", 40)
for (i in mu) {
  mu.ran.norm[[i]] <- rnorm(10, mu[[i]])
}
```

```
## Error in mu[[i]]: attempt to select more than one element in get1index <real>
```

```r
rnorm(10, mu[[1]]) # this works
```

```
##  [1]  -8.129146 -10.579671  -8.937810 -10.407187 -11.075937  -9.905442
##  [7] -10.949615 -10.183993 -11.507865  -9.281618
```

```r
# try with a list instead of a vector

mu.ran.norm <- vector("list", length(mu))
for (i in seq_along(mu)) {
  mu.ran.norm[[i]] <- rnorm(10, mu[[i]])
}

mu.ran.norm
```

```
## [[1]]
##  [1] -10.352593  -8.946093 -11.670268  -8.495920  -9.039254  -8.541076
##  [7]  -9.518769  -9.152065  -8.751079  -8.682955
## 
## [[2]]
##  [1] -0.7171514 -1.1386172 -1.0099744  0.5141224 -1.6540808 -1.5999674
##  [7]  0.8029977 -0.5663323  0.2064123  0.5296871
## 
## [[3]]
##  [1] 11.325324  9.728509 10.678996  9.790991  9.183693 11.571946  9.314173
##  [8]  9.733209 10.132906 10.322726
## 
## [[4]]
##  [1] 101.16757  99.53823 100.52611 101.03091  99.37938 101.05623  99.98211
##  [8]  99.23347 100.69264 102.67717
```

### 2. Eliminate the for loop in each of the following examples by taking advantage of an existing function that works with vectors:

The below is a paste function

```r
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}
out
```

```
## [1] "abcdefghijklmnopqrstuvwxyz"
```

```r
library(stringr)
str_c(letters, sep = "")
```

```
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
## [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

```r
length(str_c(letters, sep = ""))
```

```
## [1] 26
```

```r
str_c(letters, collapse = "")
```

```
## [1] "abcdefghijklmnopqrstuvwxyz"
```


A roundabout way to calculate the std dev


```r
x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd
```

```
## [1] 83325
```

```r
sd <- sqrt(sd / (length(x) - 1))

sd(x) # easy!
```

```
## [1] 29.01149
```
 
 


```r
x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1] # i guess this is just to give a starting valule for out[i]

for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}
out
```

```
##   [1]  0.2267523  1.1765152  1.3462617  2.2982165  2.5585288  3.3097571
##   [7]  3.5601700  3.6053983  3.8642810  3.9410533  3.9668101  4.8657059
##  [13]  5.1507832  5.9130544  5.9805711  6.8363071  7.8124092  8.0937914
##  [19]  8.6407131  9.4672417 10.3817158 11.2929259 12.0964099 12.6284383
##  [25] 12.9466199 13.9272631 13.9936469 14.8970478 15.4336224 16.2493234
##  [31] 16.8457757 17.4965591 17.9789774 18.2793144 18.4121695 19.1180876
##  [37] 19.9328286 20.0206037 20.5632058 21.5509011 22.0532385 22.1027151
##  [43] 22.6694777 22.7070802 23.6196525 24.3606463 25.1403619 25.5631899
##  [49] 25.8864355 26.3630024 27.2671455 27.8573146 28.8187019 29.2403398
##  [55] 29.8927708 30.3718336 30.5788459 30.8724750 31.7919004 32.4501712
##  [61] 33.3075202 34.2664807 34.7451976 35.4029408 36.0705943 36.9631052
##  [67] 36.9969866 37.5505460 38.5313171 38.6532860 39.6241167 40.5578719
##  [73] 41.3669381 41.4564232 41.9205011 42.5497871 43.2959519 44.2129016
##  [79] 44.3055709 45.0288744 45.5356690 46.3056312 47.0346298 47.2671649
##  [85] 48.1036675 48.8765027 49.6452931 50.0934394 50.1739037 50.2210482
##  [91] 51.0602448 52.0364737 52.9572775 53.6193720 53.8564028 54.1234716
##  [97] 54.8411930 54.9318068 55.7188288 55.9380606
```

```r
# cumulative sum

cumsum(x)
```

```
##   [1]  0.2267523  1.1765152  1.3462617  2.2982165  2.5585288  3.3097571
##   [7]  3.5601700  3.6053983  3.8642810  3.9410533  3.9668101  4.8657059
##  [13]  5.1507832  5.9130544  5.9805711  6.8363071  7.8124092  8.0937914
##  [19]  8.6407131  9.4672417 10.3817158 11.2929259 12.0964099 12.6284383
##  [25] 12.9466199 13.9272631 13.9936469 14.8970478 15.4336224 16.2493234
##  [31] 16.8457757 17.4965591 17.9789774 18.2793144 18.4121695 19.1180876
##  [37] 19.9328286 20.0206037 20.5632058 21.5509011 22.0532385 22.1027151
##  [43] 22.6694777 22.7070802 23.6196525 24.3606463 25.1403619 25.5631899
##  [49] 25.8864355 26.3630024 27.2671455 27.8573146 28.8187019 29.2403398
##  [55] 29.8927708 30.3718336 30.5788459 30.8724750 31.7919004 32.4501712
##  [61] 33.3075202 34.2664807 34.7451976 35.4029408 36.0705943 36.9631052
##  [67] 36.9969866 37.5505460 38.5313171 38.6532860 39.6241167 40.5578719
##  [73] 41.3669381 41.4564232 41.9205011 42.5497871 43.2959519 44.2129016
##  [79] 44.3055709 45.0288744 45.5356690 46.3056312 47.0346298 47.2671649
##  [85] 48.1036675 48.8765027 49.6452931 50.0934394 50.1739037 50.2210482
##  [91] 51.0602448 52.0364737 52.9572775 53.6193720 53.8564028 54.1234716
##  [97] 54.8411930 54.9318068 55.7188288 55.9380606
```

### 3. Combine your function writing and for loop skills:

Write a for loop that prints() the lyrics to the children’s song “Alice the camel”.

x <- c(5, 4, 3, 2, 1, 0)
x <- c("five","four","three", "two", "one", "no")

Alice the camel has five humps.
for (i in seq_along(x)) {
print("Alice the camel has")


### 4. It’s common to see for loops that don’t preallocate the output and instead increase the length of a vector at each step:


```r
output <- vector("integer", 0)
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
output
```

```
##   [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
##  [36] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
##  [71] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

```r
x
```

```
##   [1] 0.22675225 0.94976291 0.16974652 0.95195479 0.26031233 0.75122830
##   [7] 0.25041292 0.04522825 0.25888276 0.07677225 0.02575684 0.89889579
##  [13] 0.28507728 0.76227125 0.06751670 0.85573598 0.97610211 0.28138214
##  [19] 0.54692172 0.82652857 0.91447414 0.91121009 0.80348403 0.53202835
##  [25] 0.31818161 0.98064322 0.06638376 0.90340095 0.53657456 0.81570104
##  [31] 0.59645226 0.65078341 0.48241832 0.30033699 0.13285509 0.70591808
##  [37] 0.81474109 0.08777510 0.54260210 0.98769525 0.50233739 0.04947660
##  [43] 0.56676261 0.03760252 0.91257229 0.74099381 0.77971563 0.42282794
##  [49] 0.32324558 0.47656697 0.90414309 0.59016903 0.96138737 0.42163789
##  [55] 0.65243094 0.47906289 0.20701224 0.29362907 0.91942546 0.65827077
##  [61] 0.85734899 0.95896053 0.47871685 0.65774327 0.66765344 0.89251094
##  [67] 0.03388143 0.55355935 0.98077106 0.12196890 0.97083072 0.93375524
##  [73] 0.80906617 0.08948511 0.46407797 0.62928598 0.74616473 0.91694979
##  [79] 0.09266925 0.72330350 0.50679462 0.76996221 0.72899852 0.23253515
##  [85] 0.83650260 0.77283522 0.76879041 0.44814630 0.08046430 0.04714449
##  [91] 0.83919656 0.97622890 0.92080386 0.66209449 0.23703082 0.26706880
##  [97] 0.71772138 0.09061381 0.78702192 0.21923186
```

```r
lengths(x[[995]])
```

```
## Error in x[[995]]: subscript out of bounds
```
Test how this affects performance vs pre-allocating vector output


```r
x <- rnorm(10000)
output <- vector("integer", 0)
ptm <- proc.time()
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
proc.time() - ptm
```

```
##    user  system elapsed 
##   0.131   0.044   0.180
```

```r
#   user  system elapsed 
#  0.161   0.072   0.237 

#now preallocate
x <- rnorm(10000)
output <- vector("integer",  length(x))

ptm <- proc.time()
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
proc.time() - ptm
```

```
##    user  system elapsed 
##   0.355   0.094   0.455
```

```r
#    user  system elapsed 
#   0.384   0.158   0.546
```

Huh, I must be doing something wrong.  

## 21.3  For loop variations

```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
```

```
## # A tibble: 10 × 4
##             a          b          c          d
##         <dbl>      <dbl>      <dbl>      <dbl>
## 1   1.5794499  0.7975084  0.5971657  1.1534921
## 2   2.0320229  2.2853959  0.8312998 -1.1293853
## 3  -0.4774913  1.2578609 -0.6714369 -1.3678970
## 4   1.1699524 -0.1792025  1.3604246  0.2001011
## 5  -0.6785861 -0.6523997 -0.8153644 -0.4389375
## 6  -0.2606445 -1.1406505 -1.6684166 -0.3176377
## 7   0.8808190 -1.3187238 -0.2425558  0.8196297
## 8  -0.7099730 -0.5006427  0.4492945 -0.4620012
## 9   1.7693637  0.1013331 -0.3818610  0.7984715
## 10  0.1250648  0.2335233 -0.2490966  0.6601587
```

```r
x <- c(0, 5, 15,22, 60)
range(df$a)
```

```
## [1] -0.709973  2.032023
```

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
df
```

```
## # A tibble: 10 × 4
##             a          b         c          d
##         <dbl>      <dbl>     <dbl>      <dbl>
## 1  0.83494758 0.58717033 0.7480030 1.00000000
## 2  1.00000000 1.00000000 0.8253045 0.09459536
## 3  0.08478558 0.71489986 0.3291621 0.00000000
## 4  0.68560473 0.31617188 1.0000000 0.62187867
## 5  0.01144671 0.18487845 0.2816431 0.36843163
## 6  0.16386911 0.04940826 0.0000000 0.41653996
## 7  0.58015841 0.00000000 0.4707611 0.86758792
## 8  0.00000000 0.22698498 0.6991820 0.35928441
## 9  0.90420877 0.39400935 0.4247683 0.85919644
## 10 0.30453647 0.43068687 0.4686016 0.80434063
```

```r
# or, try the below
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
```

```
## # A tibble: 10 × 4
##              a          b          c           d
##          <dbl>      <dbl>      <dbl>       <dbl>
## 1  -0.08470209  0.7008608  0.8301649 -0.76636156
## 2  -0.25343381  1.0319260  0.2908979  0.05751249
## 3  -0.82046634  1.0615587  0.4076110  2.37536251
## 4   0.43156916  0.7738875 -0.7353228 -2.33287138
## 5  -0.28200471  2.6498251 -0.9168111  0.31589712
## 6   0.03668888 -0.7127816  1.5005496 -1.55484155
## 7  -0.26445124  0.8068816 -2.4797160  2.46449293
## 8  -0.53677311 -0.1416621 -0.8021887  1.03108798
## 9  -0.35203224 -1.0402293  0.2764882  0.77337730
## 10  0.13124561 -0.8424784 -0.5447614 -1.35540871
```

```r
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
df
```

```
## # A tibble: 10 × 4
##            a          b         c         d
##        <dbl>      <dbl>     <dbl>     <dbl>
## 1  0.5876545 0.47183319 0.8315729 0.3265355
## 2  0.4528885 0.56155144 0.6960877 0.4982702
## 3  0.0000000 0.56958186 0.7254106 0.9814210
## 4  1.0000000 0.49162333 0.4382605 0.0000000
## 5  0.4300690 1.00000000 0.3926635 0.5521299
## 6  0.6846094 0.08873790 1.0000000 0.1621786
## 7  0.4440889 0.50056469 0.0000000 1.0000000
## 8  0.2265856 0.24351055 0.4214611 0.7012099
## 9  0.3741380 0.00000000 0.6924674 0.6474907
## 10 0.7601318 0.05359023 0.4861370 0.2037499
```

note:
Typically you’ll be modifying a list or data frame with this sort of loop, so remember to use [[, not [. You might have spotted that I used [[ in all my for loops: I think it’s better to use [[ even for atomic vectors because it makes it clear that I want to work with a single element.

#### 21.3.4 while loop


```r
sample(c("T", "H"), 1)
```

```
## [1] "T"
```

```r
sample(c("T", "H"), 10, replace = T)
```

```
##  [1] "H" "T" "H" "T" "H" "H" "H" "H" "H" "H"
```

```r
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0
flip()
```

```
## [1] "H"
```

```r
while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips
```

```
## [1] 27
```


#### 21.3.5.  Exercises

##### 1. Imagine you have a directory full of CSV files that you want to read in. 
You have their paths in a vector, files <- dir("data/", pattern = "\\.csv$", full.names = TRUE), and now want to read each one with read_csv(). Write the for loop that will load them into a single data frame.



```r
files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)
# list of names of files

contents <- vector("list", length(files))

for (i in seq_along(files)){
  contents <- read_csv(files[[i]])
}

contents <- bind_row(contents)
```

```
## Error in bind_row(contents): could not find function "bind_row"
```

#### 2. What happens if you use for (nm in names(x)) and x has no names? What if only some of the elements are named? What if the names are not unique?


```r
x <- c(A = 1, B = 2, C = 3, C = 10)
names(x)
```

```
## [1] "A" "B" "C" "C"
```

```r
for (ID in names(x)){
  print(ID)
}
```

```
## [1] "A"
## [1] "B"
## [1] "C"
## [1] "C"
```

```r
x <- c(1, 5, 10, 15)
names(x) # NULL
```

```
## NULL
```

```r
for (ID in names(x)){
  print(ID)
}
 # nothing, not even an error

x <- c(A = 1, 5, 2, C = 3, C = 10)
names(x)
```

```
## [1] "A" ""  ""  "C" "C"
```

```r
for (ID in names(x)){
  print(ID)
}
```

```
## [1] "A"
## [1] ""
## [1] ""
## [1] "C"
## [1] "C"
```

```r
# at least here you get an indication that some have no names
```

#### 3. Write a function that prints the mean of each numeric column in a data frame, along with its name. For example, show_mean(iris) would print:

show_mean(iris)
 Sepal.Length: 5.84
 Sepal.Width:  3.06
 Petal.Length: 3.76
 Petal.Width:  1.20
 
 

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
names(iris) # first 4 columns are numeric
```

```
## [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
## [5] "Species"
```

```r
iris.mean <- function(df) {
  for(ID in names(df)){
    if(is.numeric(df[[ID]])) {
      cat(ID, mean(df[[ID]]))
    }
  }
}

iris.mean(iris)
```

```
## Sepal.Length 5.843333Sepal.Width 3.057333Petal.Length 3.758Petal.Width 1.199333
```

```r
# not so pretty, but so what?
```

#### 4. What does this code do? How does it work?

```r
trans <- list( 
  disp = function(x) x * 0.0163871,
  am = function(x) {
    factor(x, labels = c("auto", "manual"))
  }
)

# OK, this makes a list, disp = x* 0.016 and am now a factor.

for (var in names(trans)) { # that is, disp and am
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}
head(mtcars)
```

```
##                    mpg cyl     disp  hp drat    wt  qsec vs     am gear
## Mazda RX4         21.0   6 2.621936 110 3.90 2.620 16.46  0 manual    4
## Mazda RX4 Wag     21.0   6 2.621936 110 3.90 2.875 17.02  0 manual    4
## Datsun 710        22.8   4 1.769807  93 3.85 2.320 18.61  1 manual    4
## Hornet 4 Drive    21.4   6 4.227872 110 3.08 3.215 19.44  1   auto    3
## Hornet Sportabout 18.7   8 5.899356 175 3.15 3.440 17.02  0   auto    3
## Valiant           18.1   6 3.687098 105 2.76 3.460 20.22  1   auto    3
##                   carb
## Mazda RX4            4
## Mazda RX4 Wag        4
## Datsun 710           1
## Hornet 4 Drive       1
## Hornet Sportabout    2
## Valiant              1
```

```r
# columns are titled disp (Displacement) and am (automatic = 0, manual = 1)

trans(mtcars[[disp]])(mtcars[[disp]]) # fail
```

```
## Error in trans(mtcars[[disp]]): could not find function "trans"
```

```r
trans[["am"]](mtcars[["am"]]) # ok, that makes sense
```

```
##  [1] manual manual manual auto   auto   auto   auto   auto   auto   auto  
## [11] auto   auto   auto   auto   auto   auto   auto   manual manual manual
## [21] auto   auto   auto   auto   auto   manual manual manual manual manual
## [31] manual manual
## Levels: auto manual
```

