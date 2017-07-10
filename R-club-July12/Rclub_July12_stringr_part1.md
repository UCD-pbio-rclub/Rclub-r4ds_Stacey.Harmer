# Rclub_July12_stringR_part1.Rmd
Stacey Harmer  
7/6/2017  


For next week:

1) Section 14.1 and 14.2 in the book (and exercises)

2) The tutorial on regular expression at https://regexone.com/
when doing the regexone tutorial try to match the WHOLE line(s) of text that you are asked to match.  It will say OK as soon as you have matched at least one character in each, but try to match the whole thing.

3) The practice problems on regular expressions at https://regexone.com/problem/matching_decimal_numbers

[OPTIONAL] The beginner crosswords at https://regexcrossword.com/  (See https://regexcrossword.com/howtoplay for how to play)

**4) 14.3.5 and its exercises**

(You can skip the other parts of 14.3, they are covered by the alternate material give above).

If you a reference for regular expressions:

in R type "?regexp" 

Or https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf

# Chapter 14


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
```

## 14.2 Basics

Remember that the \ is hte escape character


```r
double_quote <- "\""
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"
# that is not as expected; because, "printed representation of the string is not the string itself"

writeLines(double_quote)
```

```
## "
```

Other special characters
\n  is newline
\t is tab

### 14.2.2  Combining strings

```r
str_c("x", "y")
```

```
## [1] "xy"
```

```r
str_c("x", "y", "z")
```

```
## [1] "xyz"
```

```r
str_c("x", "y", sep = ",")
```

```
## [1] "x,y"
```

dealing with NA


```r
x <- c("abc", NA)
str_c("|-", x, "-|")
```

```
## [1] "|-abc-|" NA
```

```r
str_c("|-", str_replace_na(x), "-|")
```

```
## [1] "|-abc-|" "|-NA-|"
```

```r
# note that objects of length 0 are silently dropped

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)
```

```
## [1] "Good morning Hadley."
```

```r
# collapse:
str_c(c("x", "y", "z")) # 3 strings
```

```
## [1] "x" "y" "z"
```

```r
str_c(c("x", "y", "z"), collapse = ", ") # 1 string
```

```
## [1] "x, y, z"
```

### 14.2.3  Subsetting strings 

For extracting parts of a string.  uses start and end arguments

```r
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
```

```
## [1] "App" "Ban" "Pea"
```

```r
str_sub(x, -3, -1) # counts backwards from end
```

```
## [1] "ple" "ana" "ear"
```

```r
str_sub("a", 1, 5)
```

```
## [1] "a"
```

```r
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
```

```
## [1] "apple"  "banana" "pear"
```

```r
# that was surprising.  x got reassigned within the string command.
```

That will be useful, if I can remember it!

### 14.2.4  Locales

Let's us specify rules used for 'to_upper' and 'to_lower'


```r
str_to_upper(c("i", "ı")) # I don't know where that character came from!
```

```
## [1] "I" "I"
```

```r
str_to_upper(c("i", "ı"), locale = "tr") 
```

```
## [1] "İ" "I"
```

sorting can also be affected by locale


```r
x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "en")
```

```
## [1] "apple"    "banana"   "eggplant"
```

```r
str_sort(x, locale = "haw")
```

```
## [1] "apple"    "eggplant" "banana"
```






