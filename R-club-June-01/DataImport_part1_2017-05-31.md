# Ch 11 - Data Import with readr



## 11.  Data Import


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

tools: read_csv, read_fwf, and red_log


```r
read_csv("a,b, c
         1,2,3
         4,5,6")
```

```
## # A tibble: 2 × 3
##       a     b     c
##   <int> <int> <int>
## 1     1     2     3
## 2     4     5     6
```

```r
#note the lack of commas at line breaks
# could have used \n instead of line break

read_csv("a,b,c \n1, 2, 3 \n4, 5, 6")
```

```
## # A tibble: 2 × 3
##       a     b     c
##   <int> <int> <int>
## 1     1     2     3
## 2     4     5     6
```

### 11.2.2  Exercises

#### 11.2.2.1  What function would you use to read a file where fields were separated with “|”?

I would use the read_delim() function
As in:

```r
read_delim("a|b\n1.0|2.0", delim = "|")
```

```
## # A tibble: 1 × 2
##       a     b
##   <dbl> <dbl>
## 1     1     2
```

#### 11.2.2.2  Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?


```r
?read_csv
```

col_names, col_types, locale, na, quoted_na, quote (that backslash is default), trim_ws, n_max, guess_max, progress

"quoted_na	
Should missing values inside quotes be treated as missing values (the default) or strings."

#### 11.2.2.3  What are the most important arguments to read_fwf()?


```r
?read_fwf

# You can specify fields either by their widths with fwf_widths() or their position with fwf_positions().
```
For read_fwf(), col_positions are created either by fwf_empty(), fwf_widths(), or fwf_positions().  This seems the key argument.   
Next in importance may be how na is treated.


```r
fwf_sample <- readr_example("fwf-sample.txt")
cat(read_lines(fwf_sample))
```

```
## John Smith          WA        418-Y11-4111 Mary Hartford       CA        319-Z19-4341 Evan Nolan          IL        219-532-c301
```

```r
# first, guess columns based on empty positions
read_fwf(fwf_sample, fwf_empty(fwf_sample, col_names = c("first", "last", "state", "ssn")))
```

```
## Parsed with column specification:
## cols(
##   first = col_character(),
##   last = col_character(),
##   state = col_character(),
##   ssn = col_character()
## )
```

```
## # A tibble: 3 × 4
##   first     last state          ssn
##   <chr>    <chr> <chr>        <chr>
## 1  John    Smith    WA 418-Y11-4111
## 2  Mary Hartford    CA 319-Z19-4341
## 3  Evan    Nolan    IL 219-532-c301
```

```r
# Or, specify width of fields
 read_fwf(fwf_sample, fwf_widths(c(20, 10, 12), c("name", "state", "ssn")))
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   state = col_character(),
##   ssn = col_character()
## )
```

```
## # A tibble: 3 × 3
##            name state          ssn
##           <chr> <chr>        <chr>
## 1    John Smith    WA 418-Y11-4111
## 2 Mary Hartford    CA 319-Z19-4341
## 3    Evan Nolan    IL 219-532-c301
```

```r
 # Or, specify width of fields
 read_fwf(fwf_sample, fwf_widths(c(20, 20, 20), c("name", "state", "ssn")))
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   state = col_character(),
##   ssn = col_character()
## )
```

```
## Warning: 3 parsing failures.
## row col expected actual                                                                                          file
##   1 ssn 20 chars      2 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/fwf-sample.txt'
##   2 ssn 20 chars      2 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/fwf-sample.txt'
##   3 ssn 20 chars      2 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/fwf-sample.txt'
```

```
## # A tibble: 3 × 3
##            name                state   ssn
##           <chr>                <chr> <chr>
## 1    John Smith WA        418-Y11-41    11
## 2 Mary Hartford CA        319-Z19-43    41
## 3    Evan Nolan IL        219-532-c3    01
```

```r
 # note that everything is offset here
 
 # tell where columns start and stop
read_fwf(fwf_sample, fwf_positions(c(1, 30), c(10, 42), c("name", "ssn"))) 
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   ssn = col_character()
## )
```

```
## # A tibble: 3 × 2
##         name          ssn
##        <chr>        <chr>
## 1 John Smith 418-Y11-4111
## 2 Mary Hartf 319-Z19-4341
## 3 Evan Nolan 219-532-c301
```

```r
# why does that work?

# next, specify the column positions
read_fwf(fwf_sample, fwf_cols(name = c(1, 10), ssn = c(30, 42))) 
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   ssn = col_character()
## )
```

```
## # A tibble: 3 × 2
##         name          ssn
##        <chr>        <chr>
## 1 John Smith 418-Y11-4111
## 2 Mary Hartf 319-Z19-4341
## 3 Evan Nolan 219-532-c301
```

```r
# note that names were truncated (to 10 characters)

# column widths
read_fwf(fwf_sample, fwf_cols(name = 20, state = 10, ssn = 12))
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   state = col_character(),
##   ssn = col_character()
## )
```

```
## # A tibble: 3 × 3
##            name state          ssn
##           <chr> <chr>        <chr>
## 1    John Smith    WA 418-Y11-4111
## 2 Mary Hartford    CA 319-Z19-4341
## 3    Evan Nolan    IL 219-532-c301
```

```r
# that seems easiest to understand

# another example

txt = c('abc\ndef')
readr::read_fwf(txt, fwf_positions(1, 2))
```

```
## # A tibble: 2 × 1
##      X1
##   <chr>
## 1    ab
## 2    de
```

```r
# I don't get it.

readr::read_fwf(txt, fwf_positions(start = 1, end = 2))
```

```
## # A tibble: 2 × 1
##      X1
##   <chr>
## 1    ab
## 2    de
```

#### 11.2.2.4  Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be surrounded by a quoting character, like " or '. By convention, read_csv() assumes that the quoting character will be ", and if you want to change it you’ll need to use read_delim() instead. What arguments do you need to specify to read the following text into a data frame?

"x,y\n1,'a,b'"


```r
ex <- "x,y\n1,'a,b'"
# I guess this is meant to be 2 rows, with one entry being a,b

read_delim(file = ex, quote = "'", delim = "," )
```

```
## # A tibble: 1 × 2
##       x     y
##   <int> <chr>
## 1     1   a,b
```

#### 11.2.2.5 Identify what is wrong with each of the following inline CSV files. What happens when you run the code?


```r
read_csv("a,b\n1,2,3\n4,5,6")  
```

```
## Warning: 2 parsing failures.
## row col  expected    actual         file
##   1  -- 2 columns 3 columns literal data
##   2  -- 2 columns 3 columns literal data
```

```
## # A tibble: 2 × 2
##       a     b
##   <int> <int>
## 1     1     2
## 2     4     5
```

```r
#first row has 2 columns while others have 3

read_csv("a,b,c\n1,2\n1,2,3,4")
```

```
## Warning: 2 parsing failures.
## row col  expected    actual         file
##   1  -- 3 columns 2 columns literal data
##   2  -- 3 columns 4 columns literal data
```

```
## # A tibble: 2 × 3
##       a     b     c
##   <int> <int> <int>
## 1     1     2    NA
## 2     1     2     3
```

```r
# first row has 3 columns, 2nd has 2, 3rd has 4

read_csv("a,b\n\"1")
```

```
## Warning: 2 parsing failures.
## row col                     expected    actual         file
##   1  a  closing quote at end of file           literal data
##   1  -- 2 columns                    1 columns literal data
```

```
## # A tibble: 1 × 2
##       a     b
##   <int> <chr>
## 1     1  <NA>
```

```r
# the backslash would need to be quoted to fill a cell

read_csv("a,b\n1,2\na,b")
```

```
## # A tibble: 2 × 2
##       a     b
##   <chr> <chr>
## 1     1     2
## 2     a     b
```

```r
# no warning.  but note that the columns are characters.  thus 1 and 2 not treated as numeric

read_csv("a;b\n1;3")
```

```
## # A tibble: 1 × 1
##   `a;b`
##   <chr>
## 1   1;3
```

```r
# need to use read_delim and specify delim = ; or use read_csv2
```

## 11.3  Parsing a vector

Different ways to deal with character vectors. 8 of them!

### 11.3.1  parsing numbers
parse_number is nice - it ignores non-numeric characters.
locale also key

### 11.3.2  parsing strings


```r
charToRaw("Hadley")
```

```
## [1] 48 61 64 6c 65 79
```

```r
charToRaw("Stacey")
```

```
## [1] 53 74 61 63 65 79
```
readr uses UTF-8 everywhere!
fine with new stuff, not good with old files

### 11.3.3  parsing factors

parse_factor() uses list of known levels

### 11.3.4  Dates, times

#### 11.3.5  Exercises

##### 11.3.5.1  What are the most important arguments to locale()?


```r
?locale
# encoding is really important.  but so are date_names and date_format, and decimal_mark
# and so is time zone! 
```

##### 11.3.5.2  What happens if you try and set decimal_mark and grouping_mark to the same character? 


```r
parse_double("1,23", locale = locale(decimal_mark = ","))
```

```
## [1] 1.23
```

```r
#parse_double("1,23", locale = locale(decimal_mark = "," , grouping_mark = ","))
 # throws an error
```

What happens to the default value of grouping_mark when you set decimal_mark to “,”? 

```r
parse_double("1000,23", locale = locale(decimal_mark = ","))
```

```
## [1] 1000.23
```

```r
# I'm going to guess the grouping_mark default would be "."

#  parse_double("1.000,23", locale = locale(decimal_mark = "," ))
#    THIS FAILED
parse_number("1.000,23", locale = locale(decimal_mark = "," ))
```

```
## [1] 1000.23
```

```r
# but this ran fine; the '.' interpreted as grouping mark

# remember that double not the same as number!
# double is strict numeric, while number is flexible
```

What happens to the default value of decimal_mark when you set the grouping_mark to “.”?

```r
parse_double("1,23", locale = locale(grouping_mark = "."))
```

```
## [1] 1.23
```

```r
# yes, default is "," becomes decimal mark

# parse_double("1.000", locale = locale(grouping_mark = "."))  
# error again

# BUT 
parse_number("1.000", locale = locale(grouping_mark = "."))  
```

```
## [1] 1000
```

```r
# runs fine

# or more succinctly:
locale(grouping_mark = ".")
```

```
## <locale>
## Numbers:  123.456,78
## Formats:  %AD / %AT
## Timezone: UTC
## Encoding: UTF-8
## <date_names>
## Days:   Sunday (Sun), Monday (Mon), Tuesday (Tue), Wednesday (Wed),
##         Thursday (Thu), Friday (Fri), Saturday (Sat)
## Months: January (Jan), February (Feb), March (Mar), April (Apr), May
##         (May), June (Jun), July (Jul), August (Aug), September
##         (Sep), October (Oct), November (Nov), December (Dec)
## AM/PM:  AM/PM
```

##### 11.3.5.3  I didn’t discuss the date_format and time_format options to locale(). What do they do? Construct an example that shows when they might be useful.

I could imagine they would be useful in distinguishing months and dates in US vs European data, for example


```r
dates <- c("1-01-70", "12-11-88", "5-06-02") 

parse_date(dates, "%m-%d-%y") # that runs since I gave it format
```

```
## [1] "1970-01-01" "1988-12-11" "2002-05-06"
```

```r
parse_date(dates, locale=locale(date_format = "%m-%d-%y")) 
```

```
## [1] "1970-01-01" "1988-12-11" "2002-05-06"
```

```r
# this would be US method

parse_date(dates, locale=locale(date_format = "%d-%m-%y")) 
```

```
## [1] "1970-01-01" "1988-11-12" "2002-06-05"
```

```r
# this would be european.
# note both methods assumed all years were in 21st century

# Note that if your subjects were born before 1970, for example, the %y won't work well
```

##### 11.3.5.4  If you live outside the US, create a new locale object that encapsulates the settings for the types of file you read most commonly.

If I lived in Argentina, I might want the following:

locale = locale(decimal_mark = ",", date_names= "es", tz =  "America/Buenos_Aires" )

##### 11.3.5.5  What’s the difference between read_csv() and read_csv2()?
read_csv is ',' delimited while read_csv2 is ';' delimited

##### 11.3.5.6 What are the most common encodings used in Europe? What are the most common encodings used in Asia? Do some googling to find out.

Europe:  Wikipedia tells me that ISO 8859-1 , ISO 8859-2, ISO 8859-3 and ISO 8859-4 are common in Europe
But there are many others.
And it seems like UTF-8 or UTF-16 would be preferred.

Asia:  Japan might use JIS X 0208, China might use GB 2312, Taiwan use Big5, etc.
But why not use UTF-32?

##### 11.3.5.7  Generate the correct format string to parse each of the following dates and times


```r
d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y", locale = locale("en"))
```

```
## [1] "2010-01-01"
```


```r
d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d", locale = locale("en"))
```

```
## [1] "2015-03-07"
```


```r
d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y", locale = locale("en"))
```

```
## [1] "2017-06-06"
```


```r
d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)", locale = locale("en"))
```

```
## [1] "2015-08-19" "2015-07-01"
```


```r
d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")
```

```
## [1] "2014-12-30"
```


```r
t1 <- "1705"  # time; I assume this would be 5:05 pm
parse_time(t1, "%H%M")
```

```
## 17:05:00
```


```r
t2 <- "11:15:10.12 PM"
parse_time(t2) # default runs OK; skips the extra fraction of second
```

```
## 23:15:10
```

```r
# or
parse_time(t2, "%I:%M:%OS %p") # more complete
```

```
## 23:15:10.12
```

## 11.4  Parsing a file


```r
challenge <- read_csv(readr_example("challenge.csv"))
```

```
## Parsed with column specification:
## cols(
##   x = col_integer(),
##   y = col_character()
## )
```

```
## Warning: 1000 parsing failures.
##  row col               expected             actual                                                                                         file
## 1001   x no trailing characters .23837975086644292 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/challenge.csv'
## 1002   x no trailing characters .41167997173033655 '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/challenge.csv'
## 1003   x no trailing characters .7460716762579978  '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/challenge.csv'
## 1004   x no trailing characters .723450553836301   '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/challenge.csv'
## 1005   x no trailing characters .614524137461558   '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/readr/extdata/challenge.csv'
## .... ... ...................... .................. ............................................................................................
## See problems(...) for more details.
```

```r
problems(challenge)
```

```
## # A tibble: 1,000 × 5
##      row   col               expected             actual
##    <int> <chr>                  <chr>              <chr>
## 1   1001     x no trailing characters .23837975086644292
## 2   1002     x no trailing characters .41167997173033655
## 3   1003     x no trailing characters  .7460716762579978
## 4   1004     x no trailing characters   .723450553836301
## 5   1005     x no trailing characters   .614524137461558
## 6   1006     x no trailing characters   .473980569280684
## 7   1007     x no trailing characters  .5784610391128808
## 8   1008     x no trailing characters  .2415937229525298
## 9   1009     x no trailing characters .11437866208143532
## 10  1010     x no trailing characters  .2983446326106787
## # ... with 990 more rows, and 1 more variables: file <chr>
```

```r
# seems likely first 1000 rows are integers but rest are not

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
#I set x to double
head(challenge)
```

```
## # A tibble: 6 × 2
##       x     y
##   <dbl> <chr>
## 1   404  <NA>
## 2  4172  <NA>
## 3  3004  <NA>
## 4   787  <NA>
## 5    37  <NA>
## 6  2332  <NA>
```

```r
tail(challenge)
```

```
## # A tibble: 6 × 2
##           x          y
##       <dbl>      <chr>
## 1 0.8052743 2019-11-21
## 2 0.1635163 2018-03-29
## 3 0.4719390 2014-08-04
## 4 0.7183186 2015-08-16
## 5 0.2698786 2020-02-04
## 6 0.6082372 2019-01-06
```

```r
# but now I see y should be a date column

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
```

```
## Parsed with column specification:
## cols(
##   x = col_double(),
##   y = col_date(format = "")
## )
```


```r
challenge2 <- read_csv(readr_example("challenge.csv"), 
  col_types = cols(.default = col_character())
)
challenge2
```

```
## # A tibble: 2,000 × 2
##        x     y
##    <chr> <chr>
## 1    404  <NA>
## 2   4172  <NA>
## 3   3004  <NA>
## 4    787  <NA>
## 5     37  <NA>
## 6   2332  <NA>
## 7   2489  <NA>
## 8   1449  <NA>
## 9   3665  <NA>
## 10  3863  <NA>
## # ... with 1,990 more rows
```

```r
type_convert(challenge2) # figured it out
```

```
## Parsed with column specification:
## cols(
##   x = col_double(),
##   y = col_date(format = "")
## )
```

```
## # A tibble: 2,000 × 2
##        x      y
##    <dbl> <date>
## 1    404   <NA>
## 2   4172   <NA>
## 3   3004   <NA>
## 4    787   <NA>
## 5     37   <NA>
## 6   2332   <NA>
## 7   2489   <NA>
## 8   1449   <NA>
## 9   3665   <NA>
## 10  3863   <NA>
## # ... with 1,990 more rows
```

Note that write_rds and read_rds are better than the csv functions if you are staying within R. 
This supports list-columns, but doesn't work with other languages.

feather works with other languages but doesn't support list-columns.
