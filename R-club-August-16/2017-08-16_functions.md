# 2017-08-16_functions.Rmd
Stacey Harmer  
8/16/2017  


Chapter 19.1 through 19.4, including the exercises. OK to skip 19.3.1 problems

# 19.2


```r
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
```

 what does range do?
 
 

```r
df$a
```

```
##  [1] 0.0000000 0.7462391 0.2430509 0.6414131 0.4188020 0.4796104 1.0000000
##  [8] 0.6796547 0.3559449 0.4862195
```

```r
range(df$a) # min and max
```

```
## [1] 0 1
```

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# can I use this with a tibble?
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df <- rescale01(df)
# YES!  except that it appears to have scaled across all the columns
```

# Excercises 19.2.1

## 1 Why is TRUE not a parameter to rescale01()? What would happen if x contained a single missing value, and na.rm was FALSE?

I think it would throw an error


```r
x <- c(5,1,-1, 0, NA, 25)
rescale01(x) # runs fine with original function ()
```

```
## [1] 0.23076923 0.07692308 0.00000000 0.03846154         NA 1.00000000
```

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = F)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)  # now all are NA
```

```
## [1] NA NA NA NA NA NA
```
That makes sense, because if one is unknown kind of by definiation all will be unknown.

## 2 In the second variant of rescale01(), infinite values are left unchanged. Rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1.

don't I need to use an if then statement?


```r
# original
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

x <- c(0, -15, Inf, -Inf, 15)
rescale01(x) # Ok, as expected
```

```
## [1]  0.5  0.0  Inf -Inf  1.0
```

```r
# new
#rescale01.Inf <- function(x) {
#  rng <- range(x, na.rm = TRUE, -Inf = 0, Inf = 1)
#  (x - rng[1]) / (rng[2] - rng[1])
#}
# that failed

rescale01.Inf <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  y <- (x - rng[1]) / (rng[2] - rng[1])
  y[y == Inf] <- 1
  y[y == -Inf] <- 0
  y
}
x
```

```
## [1]    0  -15  Inf -Inf   15
```

```r
rescale01.Inf(x)  # success
```

```
## [1] 0.5 0.0 1.0 0.0 1.0
```

##3 Practice turning the following code snippets into functions. Think about what each function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?


```r
x <- c(0, -15, NA, -2, 15)
mean(is.na(x)) # gives the fraction of entries that are NA
```

```
## [1] 0.2
```

```r
frac.na <- function(x){
  mean(is.na(x))
}  # don't see how to make it more compact
frac.na(x) 
```

```
## [1] 0.2
```

```r
x / sum(x, na.rm = TRUE)
```

```
## [1]  0.0  7.5   NA  1.0 -7.5
```

```r
# this returns normalized values
norm.x <- function(x){
  sum <- sum(x, na.rm = TRUE)
  x/sum
}
norm.x(x)  # seems fine
```

```
## [1]  0.0  7.5   NA  1.0 -7.5
```

```r
sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
```

```
## [1] -24.57641
```

```r
# this is the coeff of variation

covar.x <- function(x){
  sd.x <- sd(x, na.rm = TRUE)
  mean.x <- mean(x, na.rm = TRUE)
  sd.x/mean.x
}

covar.x(x)
```

```
## [1] -24.57641
```

##4 Follow http://nicercode.github.io/intro/writing-functions.html to write your own functions to compute the variance and skew of a numeric vector.

Variance example is given on that web page

```r
# sample variance: 1/(n-1) * sum (x - mean.x)2

n <- length(x) # number of items in vector

# difference between x values and mean of x
m <- mean(x,na.rm = TRUE)
x - m
```

```
## [1]   0.5 -14.5    NA  -1.5  15.5
```

```r
sum((x-m)^2, na.rm = TRUE)
```

```
## [1] 453
```

```r
variance.x <- function(x){
  n <- length(x)
  m <- mean(x, na.rm = TRUE)
  (1/(n-1))* sum((x-m)^2, na.rm = TRUE)
}

variance.x(x)
```

```
## [1] 113.25
```

```r
var(x, na.rm = TRUE) # don't match; probably because of NA not being omitted from length
```

```
## [1] 151
```

```r
x <- c(0, 5, 15, 22, -5)
# yes, that is correct

# answer page has more elegant way to deal with NA:

variance <- function(x) {
  # remove missing values
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  sq_err <- (x - m) ^ 2
  sum(sq_err) / (n - 1)
}
```

Now, write a function to define skew


```r
skewness <- function(x) {
    n <- length(x)
    v <- var(x)
    m <- mean(x)
    third.moment <- (1/(n - 2)) * sum((x - m)^3)
    third.moment/(var(x)^(3/2))
}

skewness(x) # that doesn't seem right to me
```

```
## [1] 0.3057592
```

```r
# and from the answer page:
skewness <- function(x) {
  x <- x[!is.na(x)] 
  n <- length(x)
  m <- mean(x)
  m3 <- sum((x - m) ^ 3) / n
  s3 <- sqrt(sum((x - m) ^ 2) / (n - 1))
  m3 / s3
}
skewness(rgamma(10, 1, 1)) # doesn't seem right either (why is s3 transformed by sqrt instead of by ^(3/2)?)
```

```
## [1] 1.392365
```

##5 Write both_na(), a function that takes two vectors of the same length and returns the number of positions that have an NA in both vectors.

That seems difficult.  STart by doing this for one vector

```r
y <- c(0, -5, NA, NA, 10, 22)
length(y)
```

```
## [1] 6
```

```r
Z <- c(0, NA, NA, 5, 5) # Vector of T and F.  I want 
ZZ <- c(5, 5, NA, NA, 10)  # I want to return info on T and T in same position in both vectors

Z & ZZ # look for overlap between these vectors
```

```
## [1] FALSE    NA    NA    NA  TRUE
```

```r
sum(Z & ZZ)
```

```
## [1] NA
```

```r
both_na <- function (x, y){
  x.na <- is.na(x)
  y.na <- is.na(y)
  sum(x.na & y.na)
}

both_na(Z, ZZ)
```

```
## [1] 1
```

##6 What do the following functions do? Why are they useful even though they are so short?


```r
is_directory <- function(x) file.info(x)$isdir
# output is going to be brief; likely could use this very often.
# tells you if the file is a directory or not

is_readable <- function(x) file.access(x, 4) == 0
# as above, but tells you if file can be read
```

##7 Read the complete lyrics to “Little Bunny Foo Foo”. There’s a lot of duplication in this song. Extend the initial piping example to recreate the complete song, and use functions to reduce the duplication.

Little bunny Foo Foo
Went hopping through the forest
Scooping up the field mice
And bopping them on the head

Down came the Good Fairy, and she said
"Little bunny Foo Foo
I don't want to see you
Scooping up the field mice
And bopping them on the head."
I'll give you three chances,
And if you don't behave, I will turn you into a goon!"
And the next day...

The verses repeat subtracting each chance by one until the final verse which the fairy said

"I gave you three chances and you didn't behave so....
POOF. She turned him into a Goon."

Pipe example

library(tidyverse)
# first verse
foo.action <- function(){
  foo_foo %>%
  hop(through = forest) %>%
  scoop(up = field_mouse) %>%
  bop(on = head)
}


# second verse
fairy.says <- function(){
  good_fairy %>%
  says(who = foo_foo) %>%
  wants(see != foo_foo) %>%
  scoop(up = field_mouse) %>%
  bop(on = head)
}

fairy.threat <- function(n){
  good_fairy %>%
    gives(chances = n)
  if(behave = FALSE)
    then "turn_into_goon"
  else
    foo_foo
}


Something like that

# 19.3  Functions are for humans and computers

# 19.4  Conditional execution (if/else statements!)

Example

```r
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
z <- c(1:3)
names(z)
```

```
## NULL
```

```r
## assign just one name
names(z)[2:3] <- c("b","")

has_name(z)
```

```
## [1] FALSE  TRUE FALSE
```

## 19.4.2 Multiple Conditions

Can use if, else if, and else chained together. 
Or  the switch() function.

I would have benefitted from some examples here



## 19.4.4 Exercises

## 1 What’s the difference between if and ifelse()? Carefully read the help and construct three examples that illustrate the key differences.

?'if'
If condition is vector of length > 1, only hte first element is used. 

Examples

```r
for(i in 1:5) print(1:i)
```

```
## [1] 1
## [1] 1 2
## [1] 1 2 3
## [1] 1 2 3 4
## [1] 1 2 3 4 5
```

```r
for(n in c(2,5,10,20,50)) {
   x <- stats::rnorm(n)
   cat(n, ": ", sum(x^2), "\n", sep = "")
}
```

```
## 2: 1.505389
## 5: 0.4508815
## 10: 15.67254
## 20: 20.61228
## 50: 44.55424
```

```r
f <- factor(sample(letters[1:5], 10, replace = TRUE))

for(i in unique(f)) print(i)
```

```
## [1] "b"
## [1] "e"
## [1] "a"
## [1] "d"
```

I guess we can think of it as an operation that is repeated until the input is exhausted (so will repeat same operation multiple times)

ifelse - you have a choice of operations

examples

```r
x <- c(6:-4)
sqrt(x)  #- gives warning
```

```
## Warning in sqrt(x): NaNs produced
```

```
##  [1] 2.449490 2.236068 2.000000 1.732051 1.414214 1.000000 0.000000
##  [8]      NaN      NaN      NaN      NaN
```

```r
sqrt(ifelse(x >= 0, x, NA))  # no warning
```

```
##  [1] 2.449490 2.236068 2.000000 1.732051 1.414214 1.000000 0.000000
##  [8]       NA       NA       NA       NA
```

```r
# this means: if x >= 0, get sqrt (put x into function).  otherwise, return NA

## Note: the following also gives the warning !
ifelse(x >= 0, sqrt(x), NA)
```

```
## Warning in sqrt(x): NaNs produced
```

```
##  [1] 2.449490 2.236068 2.000000 1.732051 1.414214 1.000000 0.000000
##  [8]       NA       NA       NA       NA
```

```r
## ifelse() strips attributes
## This is important when working with Dates and factors
x <- seq(as.Date("2000-02-29"), as.Date("2004-10-04"), by = "1 month")
## has many "yyyy-mm-29", but a few "yyyy-03-01" in the non-leap years

y <- ifelse(as.POSIXlt(x)$mday == 29, x, NA)
head(y) # not what you expected ... ==> need restore the class attribute:
```

```
## [1] 11016 11045 11076 11106 11137 11167
```

```r
class(y) <- class(x)
y
```

```
##  [1] "2000-02-29" "2000-03-29" "2000-04-29" "2000-05-29" "2000-06-29"
##  [6] "2000-07-29" "2000-08-29" "2000-09-29" "2000-10-29" "2000-11-29"
## [11] "2000-12-29" "2001-01-29" NA           "2001-03-29" "2001-04-29"
## [16] "2001-05-29" "2001-06-29" "2001-07-29" "2001-08-29" "2001-09-29"
## [21] "2001-10-29" "2001-11-29" "2001-12-29" "2002-01-29" NA          
## [26] "2002-03-29" "2002-04-29" "2002-05-29" "2002-06-29" "2002-07-29"
## [31] "2002-08-29" "2002-09-29" "2002-10-29" "2002-11-29" "2002-12-29"
## [36] "2003-01-29" NA           "2003-03-29" "2003-04-29" "2003-05-29"
## [41] "2003-06-29" "2003-07-29" "2003-08-29" "2003-09-29" "2003-10-29"
## [46] "2003-11-29" "2003-12-29" "2004-01-29" "2004-02-29" "2004-03-29"
## [51] "2004-04-29" "2004-05-29" "2004-06-29" "2004-07-29" "2004-08-29"
## [56] "2004-09-29"
```

## 2 Write a greeting function that says “good morning”, “good afternoon”, or “good evening”, depending on the time of day. (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)

Not easy for those of us that skipped lubridate


```r
greet <- function(time = lubridate::now()) {
  hr <- hour(time)
  # I don't know what to do about times after midnight, 
  # are they evening or morning?
  if (hr < 12) {
    print("good morning")
  } else if (hr < 17) {
    print("good afternoon")
  } else {
    print("good evening")
  }
} 

library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following object is masked from 'package:base':
## 
##     date
```

```r
now("EST")
```

```
## [1] "2017-08-16 17:40:33 EST"
```

```r
now("PST")
```

```
## Warning in as.POSIXlt.POSIXct(x, tz): unknown timezone 'PST'
```

```
## [1] "2017-08-16 22:40:33 GMT"
```

```r
now("GH")
```

```
## Warning in as.POSIXlt.POSIXct(x, tz): unknown timezone 'GH'
```

```
## [1] "2017-08-16 22:40:33 GMT"
```

```r
now("UTC")
```

```
## [1] "2017-08-16 22:40:33 UTC"
```

```r
now("UTC+13:00")
```

```
## Warning in as.POSIXlt.POSIXct(x, tz): unknown timezone 'UTC+13:00'
```

```
## [1] "2017-08-16 09:40:33 UTC"
```

```r
OlsonNames() 
```

```
##   [1] "Africa/Abidjan"                   "Africa/Accra"                    
##   [3] "Africa/Addis_Ababa"               "Africa/Algiers"                  
##   [5] "Africa/Asmara"                    "Africa/Asmera"                   
##   [7] "Africa/Bamako"                    "Africa/Bangui"                   
##   [9] "Africa/Banjul"                    "Africa/Bissau"                   
##  [11] "Africa/Blantyre"                  "Africa/Brazzaville"              
##  [13] "Africa/Bujumbura"                 "Africa/Cairo"                    
##  [15] "Africa/Casablanca"                "Africa/Ceuta"                    
##  [17] "Africa/Conakry"                   "Africa/Dakar"                    
##  [19] "Africa/Dar_es_Salaam"             "Africa/Djibouti"                 
##  [21] "Africa/Douala"                    "Africa/El_Aaiun"                 
##  [23] "Africa/Freetown"                  "Africa/Gaborone"                 
##  [25] "Africa/Harare"                    "Africa/Johannesburg"             
##  [27] "Africa/Juba"                      "Africa/Kampala"                  
##  [29] "Africa/Khartoum"                  "Africa/Kigali"                   
##  [31] "Africa/Kinshasa"                  "Africa/Lagos"                    
##  [33] "Africa/Libreville"                "Africa/Lome"                     
##  [35] "Africa/Luanda"                    "Africa/Lubumbashi"               
##  [37] "Africa/Lusaka"                    "Africa/Malabo"                   
##  [39] "Africa/Maputo"                    "Africa/Maseru"                   
##  [41] "Africa/Mbabane"                   "Africa/Mogadishu"                
##  [43] "Africa/Monrovia"                  "Africa/Nairobi"                  
##  [45] "Africa/Ndjamena"                  "Africa/Niamey"                   
##  [47] "Africa/Nouakchott"                "Africa/Ouagadougou"              
##  [49] "Africa/Porto-Novo"                "Africa/Sao_Tome"                 
##  [51] "Africa/Timbuktu"                  "Africa/Tripoli"                  
##  [53] "Africa/Tunis"                     "Africa/Windhoek"                 
##  [55] "America/Adak"                     "America/Anchorage"               
##  [57] "America/Anguilla"                 "America/Antigua"                 
##  [59] "America/Araguaina"                "America/Argentina/Buenos_Aires"  
##  [61] "America/Argentina/Catamarca"      "America/Argentina/ComodRivadavia"
##  [63] "America/Argentina/Cordoba"        "America/Argentina/Jujuy"         
##  [65] "America/Argentina/La_Rioja"       "America/Argentina/Mendoza"       
##  [67] "America/Argentina/Rio_Gallegos"   "America/Argentina/Salta"         
##  [69] "America/Argentina/San_Juan"       "America/Argentina/San_Luis"      
##  [71] "America/Argentina/Tucuman"        "America/Argentina/Ushuaia"       
##  [73] "America/Aruba"                    "America/Asuncion"                
##  [75] "America/Atikokan"                 "America/Atka"                    
##  [77] "America/Bahia"                    "America/Bahia_Banderas"          
##  [79] "America/Barbados"                 "America/Belem"                   
##  [81] "America/Belize"                   "America/Blanc-Sablon"            
##  [83] "America/Boa_Vista"                "America/Bogota"                  
##  [85] "America/Boise"                    "America/Buenos_Aires"            
##  [87] "America/Cambridge_Bay"            "America/Campo_Grande"            
##  [89] "America/Cancun"                   "America/Caracas"                 
##  [91] "America/Catamarca"                "America/Cayenne"                 
##  [93] "America/Cayman"                   "America/Chicago"                 
##  [95] "America/Chihuahua"                "America/Coral_Harbour"           
##  [97] "America/Cordoba"                  "America/Costa_Rica"              
##  [99] "America/Creston"                  "America/Cuiaba"                  
## [101] "America/Curacao"                  "America/Danmarkshavn"            
## [103] "America/Dawson"                   "America/Dawson_Creek"            
## [105] "America/Denver"                   "America/Detroit"                 
## [107] "America/Dominica"                 "America/Edmonton"                
## [109] "America/Eirunepe"                 "America/El_Salvador"             
## [111] "America/Ensenada"                 "America/Fort_Nelson"             
## [113] "America/Fort_Wayne"               "America/Fortaleza"               
## [115] "America/Glace_Bay"                "America/Godthab"                 
## [117] "America/Goose_Bay"                "America/Grand_Turk"              
## [119] "America/Grenada"                  "America/Guadeloupe"              
## [121] "America/Guatemala"                "America/Guayaquil"               
## [123] "America/Guyana"                   "America/Halifax"                 
## [125] "America/Havana"                   "America/Hermosillo"              
## [127] "America/Indiana/Indianapolis"     "America/Indiana/Knox"            
## [129] "America/Indiana/Marengo"          "America/Indiana/Petersburg"      
## [131] "America/Indiana/Tell_City"        "America/Indiana/Vevay"           
## [133] "America/Indiana/Vincennes"        "America/Indiana/Winamac"         
## [135] "America/Indianapolis"             "America/Inuvik"                  
## [137] "America/Iqaluit"                  "America/Jamaica"                 
## [139] "America/Jujuy"                    "America/Juneau"                  
## [141] "America/Kentucky/Louisville"      "America/Kentucky/Monticello"     
## [143] "America/Knox_IN"                  "America/Kralendijk"              
## [145] "America/La_Paz"                   "America/Lima"                    
## [147] "America/Los_Angeles"              "America/Louisville"              
## [149] "America/Lower_Princes"            "America/Maceio"                  
## [151] "America/Managua"                  "America/Manaus"                  
## [153] "America/Marigot"                  "America/Martinique"              
## [155] "America/Matamoros"                "America/Mazatlan"                
## [157] "America/Mendoza"                  "America/Menominee"               
## [159] "America/Merida"                   "America/Metlakatla"              
## [161] "America/Mexico_City"              "America/Miquelon"                
## [163] "America/Moncton"                  "America/Monterrey"               
## [165] "America/Montevideo"               "America/Montreal"                
## [167] "America/Montserrat"               "America/Nassau"                  
## [169] "America/New_York"                 "America/Nipigon"                 
## [171] "America/Nome"                     "America/Noronha"                 
## [173] "America/North_Dakota/Beulah"      "America/North_Dakota/Center"     
## [175] "America/North_Dakota/New_Salem"   "America/Ojinaga"                 
## [177] "America/Panama"                   "America/Pangnirtung"             
## [179] "America/Paramaribo"               "America/Phoenix"                 
## [181] "America/Port_of_Spain"            "America/Port-au-Prince"          
## [183] "America/Porto_Acre"               "America/Porto_Velho"             
## [185] "America/Puerto_Rico"              "America/Punta_Arenas"            
## [187] "America/Rainy_River"              "America/Rankin_Inlet"            
## [189] "America/Recife"                   "America/Regina"                  
## [191] "America/Resolute"                 "America/Rio_Branco"              
## [193] "America/Rosario"                  "America/Santa_Isabel"            
## [195] "America/Santarem"                 "America/Santiago"                
## [197] "America/Santo_Domingo"            "America/Sao_Paulo"               
## [199] "America/Scoresbysund"             "America/Shiprock"                
## [201] "America/Sitka"                    "America/St_Barthelemy"           
## [203] "America/St_Johns"                 "America/St_Kitts"                
## [205] "America/St_Lucia"                 "America/St_Thomas"               
## [207] "America/St_Vincent"               "America/Swift_Current"           
## [209] "America/Tegucigalpa"              "America/Thule"                   
## [211] "America/Thunder_Bay"              "America/Tijuana"                 
## [213] "America/Toronto"                  "America/Tortola"                 
## [215] "America/Vancouver"                "America/Virgin"                  
## [217] "America/Whitehorse"               "America/Winnipeg"                
## [219] "America/Yakutat"                  "America/Yellowknife"             
## [221] "Antarctica/Casey"                 "Antarctica/Davis"                
## [223] "Antarctica/DumontDUrville"        "Antarctica/Macquarie"            
## [225] "Antarctica/Mawson"                "Antarctica/McMurdo"              
## [227] "Antarctica/Palmer"                "Antarctica/Rothera"              
## [229] "Antarctica/South_Pole"            "Antarctica/Syowa"                
## [231] "Antarctica/Troll"                 "Antarctica/Vostok"               
## [233] "Arctic/Longyearbyen"              "Asia/Aden"                       
## [235] "Asia/Almaty"                      "Asia/Amman"                      
## [237] "Asia/Anadyr"                      "Asia/Aqtau"                      
## [239] "Asia/Aqtobe"                      "Asia/Ashgabat"                   
## [241] "Asia/Ashkhabad"                   "Asia/Atyrau"                     
## [243] "Asia/Baghdad"                     "Asia/Bahrain"                    
## [245] "Asia/Baku"                        "Asia/Bangkok"                    
## [247] "Asia/Barnaul"                     "Asia/Beirut"                     
## [249] "Asia/Bishkek"                     "Asia/Brunei"                     
## [251] "Asia/Calcutta"                    "Asia/Chita"                      
## [253] "Asia/Choibalsan"                  "Asia/Chongqing"                  
## [255] "Asia/Chungking"                   "Asia/Colombo"                    
## [257] "Asia/Dacca"                       "Asia/Damascus"                   
## [259] "Asia/Dhaka"                       "Asia/Dili"                       
## [261] "Asia/Dubai"                       "Asia/Dushanbe"                   
## [263] "Asia/Famagusta"                   "Asia/Gaza"                       
## [265] "Asia/Harbin"                      "Asia/Hebron"                     
## [267] "Asia/Ho_Chi_Minh"                 "Asia/Hong_Kong"                  
## [269] "Asia/Hovd"                        "Asia/Irkutsk"                    
## [271] "Asia/Istanbul"                    "Asia/Jakarta"                    
## [273] "Asia/Jayapura"                    "Asia/Jerusalem"                  
## [275] "Asia/Kabul"                       "Asia/Kamchatka"                  
## [277] "Asia/Karachi"                     "Asia/Kashgar"                    
## [279] "Asia/Kathmandu"                   "Asia/Katmandu"                   
## [281] "Asia/Khandyga"                    "Asia/Kolkata"                    
## [283] "Asia/Krasnoyarsk"                 "Asia/Kuala_Lumpur"               
## [285] "Asia/Kuching"                     "Asia/Kuwait"                     
## [287] "Asia/Macao"                       "Asia/Macau"                      
## [289] "Asia/Magadan"                     "Asia/Makassar"                   
## [291] "Asia/Manila"                      "Asia/Muscat"                     
## [293] "Asia/Nicosia"                     "Asia/Novokuznetsk"               
## [295] "Asia/Novosibirsk"                 "Asia/Omsk"                       
## [297] "Asia/Oral"                        "Asia/Phnom_Penh"                 
## [299] "Asia/Pontianak"                   "Asia/Pyongyang"                  
## [301] "Asia/Qatar"                       "Asia/Qyzylorda"                  
## [303] "Asia/Rangoon"                     "Asia/Riyadh"                     
## [305] "Asia/Saigon"                      "Asia/Sakhalin"                   
## [307] "Asia/Samarkand"                   "Asia/Seoul"                      
## [309] "Asia/Shanghai"                    "Asia/Singapore"                  
## [311] "Asia/Srednekolymsk"               "Asia/Taipei"                     
## [313] "Asia/Tashkent"                    "Asia/Tbilisi"                    
## [315] "Asia/Tehran"                      "Asia/Tel_Aviv"                   
## [317] "Asia/Thimbu"                      "Asia/Thimphu"                    
## [319] "Asia/Tokyo"                       "Asia/Tomsk"                      
## [321] "Asia/Ujung_Pandang"               "Asia/Ulaanbaatar"                
## [323] "Asia/Ulan_Bator"                  "Asia/Urumqi"                     
## [325] "Asia/Ust-Nera"                    "Asia/Vientiane"                  
## [327] "Asia/Vladivostok"                 "Asia/Yakutsk"                    
## [329] "Asia/Yangon"                      "Asia/Yekaterinburg"              
## [331] "Asia/Yerevan"                     "Atlantic/Azores"                 
## [333] "Atlantic/Bermuda"                 "Atlantic/Canary"                 
## [335] "Atlantic/Cape_Verde"              "Atlantic/Faeroe"                 
## [337] "Atlantic/Faroe"                   "Atlantic/Jan_Mayen"              
## [339] "Atlantic/Madeira"                 "Atlantic/Reykjavik"              
## [341] "Atlantic/South_Georgia"           "Atlantic/St_Helena"              
## [343] "Atlantic/Stanley"                 "Australia/ACT"                   
## [345] "Australia/Adelaide"               "Australia/Brisbane"              
## [347] "Australia/Broken_Hill"            "Australia/Canberra"              
## [349] "Australia/Currie"                 "Australia/Darwin"                
## [351] "Australia/Eucla"                  "Australia/Hobart"                
## [353] "Australia/LHI"                    "Australia/Lindeman"              
## [355] "Australia/Lord_Howe"              "Australia/Melbourne"             
## [357] "Australia/North"                  "Australia/NSW"                   
## [359] "Australia/Perth"                  "Australia/Queensland"            
## [361] "Australia/South"                  "Australia/Sydney"                
## [363] "Australia/Tasmania"               "Australia/Victoria"              
## [365] "Australia/West"                   "Australia/Yancowinna"            
## [367] "Brazil/Acre"                      "Brazil/DeNoronha"                
## [369] "Brazil/East"                      "Brazil/West"                     
## [371] "Canada/Atlantic"                  "Canada/Central"                  
## [373] "Canada/East-Saskatchewan"         "Canada/Eastern"                  
## [375] "Canada/Mountain"                  "Canada/Newfoundland"             
## [377] "Canada/Pacific"                   "Canada/Saskatchewan"             
## [379] "Canada/Yukon"                     "CET"                             
## [381] "Chile/Continental"                "Chile/EasterIsland"              
## [383] "CST6CDT"                          "Cuba"                            
## [385] "EET"                              "Egypt"                           
## [387] "Eire"                             "EST"                             
## [389] "EST5EDT"                          "Etc/GMT"                         
## [391] "Etc/GMT-0"                        "Etc/GMT-1"                       
## [393] "Etc/GMT-10"                       "Etc/GMT-11"                      
## [395] "Etc/GMT-12"                       "Etc/GMT-13"                      
## [397] "Etc/GMT-14"                       "Etc/GMT-2"                       
## [399] "Etc/GMT-3"                        "Etc/GMT-4"                       
## [401] "Etc/GMT-5"                        "Etc/GMT-6"                       
## [403] "Etc/GMT-7"                        "Etc/GMT-8"                       
## [405] "Etc/GMT-9"                        "Etc/GMT+0"                       
## [407] "Etc/GMT+1"                        "Etc/GMT+10"                      
## [409] "Etc/GMT+11"                       "Etc/GMT+12"                      
## [411] "Etc/GMT+2"                        "Etc/GMT+3"                       
## [413] "Etc/GMT+4"                        "Etc/GMT+5"                       
## [415] "Etc/GMT+6"                        "Etc/GMT+7"                       
## [417] "Etc/GMT+8"                        "Etc/GMT+9"                       
## [419] "Etc/GMT0"                         "Etc/Greenwich"                   
## [421] "Etc/UCT"                          "Etc/Universal"                   
## [423] "Etc/UTC"                          "Etc/Zulu"                        
## [425] "Europe/Amsterdam"                 "Europe/Andorra"                  
## [427] "Europe/Astrakhan"                 "Europe/Athens"                   
## [429] "Europe/Belfast"                   "Europe/Belgrade"                 
## [431] "Europe/Berlin"                    "Europe/Bratislava"               
## [433] "Europe/Brussels"                  "Europe/Bucharest"                
## [435] "Europe/Budapest"                  "Europe/Busingen"                 
## [437] "Europe/Chisinau"                  "Europe/Copenhagen"               
## [439] "Europe/Dublin"                    "Europe/Gibraltar"                
## [441] "Europe/Guernsey"                  "Europe/Helsinki"                 
## [443] "Europe/Isle_of_Man"               "Europe/Istanbul"                 
## [445] "Europe/Jersey"                    "Europe/Kaliningrad"              
## [447] "Europe/Kiev"                      "Europe/Kirov"                    
## [449] "Europe/Lisbon"                    "Europe/Ljubljana"                
## [451] "Europe/London"                    "Europe/Luxembourg"               
## [453] "Europe/Madrid"                    "Europe/Malta"                    
## [455] "Europe/Mariehamn"                 "Europe/Minsk"                    
## [457] "Europe/Monaco"                    "Europe/Moscow"                   
## [459] "Europe/Nicosia"                   "Europe/Oslo"                     
## [461] "Europe/Paris"                     "Europe/Podgorica"                
## [463] "Europe/Prague"                    "Europe/Riga"                     
## [465] "Europe/Rome"                      "Europe/Samara"                   
## [467] "Europe/San_Marino"                "Europe/Sarajevo"                 
## [469] "Europe/Saratov"                   "Europe/Simferopol"               
## [471] "Europe/Skopje"                    "Europe/Sofia"                    
## [473] "Europe/Stockholm"                 "Europe/Tallinn"                  
## [475] "Europe/Tirane"                    "Europe/Tiraspol"                 
## [477] "Europe/Ulyanovsk"                 "Europe/Uzhgorod"                 
## [479] "Europe/Vaduz"                     "Europe/Vatican"                  
## [481] "Europe/Vienna"                    "Europe/Vilnius"                  
## [483] "Europe/Volgograd"                 "Europe/Warsaw"                   
## [485] "Europe/Zagreb"                    "Europe/Zaporozhye"               
## [487] "Europe/Zurich"                    "GB"                              
## [489] "GB-Eire"                          "GMT"                             
## [491] "GMT-0"                            "GMT+0"                           
## [493] "GMT0"                             "Greenwich"                       
## [495] "Hongkong"                         "HST"                             
## [497] "Iceland"                          "Indian/Antananarivo"             
## [499] "Indian/Chagos"                    "Indian/Christmas"                
## [501] "Indian/Cocos"                     "Indian/Comoro"                   
## [503] "Indian/Kerguelen"                 "Indian/Mahe"                     
## [505] "Indian/Maldives"                  "Indian/Mauritius"                
## [507] "Indian/Mayotte"                   "Indian/Reunion"                  
## [509] "Iran"                             "Israel"                          
## [511] "Jamaica"                          "Japan"                           
## [513] "Kwajalein"                        "Libya"                           
## [515] "MET"                              "Mexico/BajaNorte"                
## [517] "Mexico/BajaSur"                   "Mexico/General"                  
## [519] "MST"                              "MST7MDT"                         
## [521] "Navajo"                           "NZ"                              
## [523] "NZ-CHAT"                          "Pacific/Apia"                    
## [525] "Pacific/Auckland"                 "Pacific/Bougainville"            
## [527] "Pacific/Chatham"                  "Pacific/Chuuk"                   
## [529] "Pacific/Easter"                   "Pacific/Efate"                   
## [531] "Pacific/Enderbury"                "Pacific/Fakaofo"                 
## [533] "Pacific/Fiji"                     "Pacific/Funafuti"                
## [535] "Pacific/Galapagos"                "Pacific/Gambier"                 
## [537] "Pacific/Guadalcanal"              "Pacific/Guam"                    
## [539] "Pacific/Honolulu"                 "Pacific/Johnston"                
## [541] "Pacific/Kiritimati"               "Pacific/Kosrae"                  
## [543] "Pacific/Kwajalein"                "Pacific/Majuro"                  
## [545] "Pacific/Marquesas"                "Pacific/Midway"                  
## [547] "Pacific/Nauru"                    "Pacific/Niue"                    
## [549] "Pacific/Norfolk"                  "Pacific/Noumea"                  
## [551] "Pacific/Pago_Pago"                "Pacific/Palau"                   
## [553] "Pacific/Pitcairn"                 "Pacific/Pohnpei"                 
## [555] "Pacific/Ponape"                   "Pacific/Port_Moresby"            
## [557] "Pacific/Rarotonga"                "Pacific/Saipan"                  
## [559] "Pacific/Samoa"                    "Pacific/Tahiti"                  
## [561] "Pacific/Tarawa"                   "Pacific/Tongatapu"               
## [563] "Pacific/Truk"                     "Pacific/Wake"                    
## [565] "Pacific/Wallis"                   "Pacific/Yap"                     
## [567] "Poland"                           "Portugal"                        
## [569] "PRC"                              "PST8PDT"                         
## [571] "ROC"                              "ROK"                             
## [573] "Singapore"                        "Turkey"                          
## [575] "UCT"                              "Universal"                       
## [577] "US/Alaska"                        "US/Aleutian"                     
## [579] "US/Arizona"                       "US/Central"                      
## [581] "US/East-Indiana"                  "US/Eastern"                      
## [583] "US/Hawaii"                        "US/Indiana-Starke"               
## [585] "US/Michigan"                      "US/Mountain"                     
## [587] "US/Pacific"                       "US/Pacific-New"                  
## [589] "US/Samoa"                         "UTC"                             
## [591] "VERSION"                          "W-SU"                            
## [593] "WET"                              "Zulu"
```

```r
now("US/Pacific")
```

```
## [1] "2017-08-16 15:40:33 PDT"
```

## 3 Implement a fizzbuzz function. It takes a single number as input. If the number is divisible by three, it returns “fizz”. If it’s divisible by five it returns “buzz”. If it’s divisible by three and five, it returns “fizzbuzz”. Otherwise, it returns the number. Make sure you first write working code before you create the function.


```r
101 %/% 5
```

```
## [1] 20
```

```r
101 %% 5  # that is what I want;
```

```
## [1] 1
```

```r
# divisible by 3:
9 %% 3  # gives 0
```

```
## [1] 0
```

```r
x <- 15

# if (x %% 3 == 0) & (x %% 5 == 0) {  ### why isn't this equivalent to example from help page?
#  print("fizzbuzz")
#} else if (x %% 3 == 0) {
#  print("fizz")
#} else if (x %% 5 == 0) {
#  print("buzz")
#} else {
#  x 
# }

# this prints all 4 evaulations - why?



## why does !(x %% 3)  evalute as TRUE ?
!(16 %% 3) # F
```

```
## [1] FALSE
```

```r
!(9 %% 3) # T
```

```
## [1] TRUE
```

```r
# from help page:
fizzbuzz <- function(x) {
  stopifnot(length(x) == 1)
  stopifnot(is.numeric(x))
  # this could be made more efficient by minimizing the
  # number of tests
  if (!(x %% 3) & !(x %% 5)) {
    print("fizzbuzz")
  } else if (!(x %% 3)) {
    print("fizz")
  } else if (!(x %% 5)) {
    print("buzz")
  }
}
fizzbuzz(6)
```

```
## [1] "fizz"
```

```r
#> [1] "fizz"
fizzbuzz(10)
```

```
## [1] "buzz"
```

```r
#> [1] "buzz"
fizzbuzz(15)
```

```
## [1] "fizzbuzz"
```

```r
#> [1] "fizzbuzz"
fizzbuzz(2)
```



