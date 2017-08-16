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

### 14.2.5 Exercises

#### 14.2.5.1  In code that doesn’t use stringr, you’ll often see paste() and paste0(). What’s the difference between the two functions? What stringr function are they equivalent to? How do the functions differ in their handling of NA?


```r
?paste
x <- c("apple", "eggplant", "banana")
paste(x, "y") # sep default is a space
```

```
## [1] "apple y"    "eggplant y" "banana y"
```

```r
paste0(x, "y") # sep default is nothing
```

```
## [1] "appley"    "eggplanty" "bananay"
```

```r
str_c(x, "y") # so this is like paste0
```

```
## [1] "appley"    "eggplanty" "bananay"
```

```r
str_c(x, "y", sep = " ") # would be like paste
```

```
## [1] "apple y"    "eggplant y" "banana y"
```

How are NA handled?


```r
y <- c("apple", "eggplant", NA, "banana")
paste(y, "z")  # pretends NA is a value
```

```
## [1] "apple z"    "eggplant z" "NA z"       "banana z"
```

```r
paste0(y, "z") # same
```

```
## [1] "applez"    "eggplantz" "NAz"       "bananaz"
```

```r
str_c(y, "z") # NA is contagious; just NA in output
```

```
## [1] "applez"    "eggplantz" NA          "bananaz"
```

#### 14.2.5.2 In your own words, describe the difference between the sep and collapse arguments to str_c().

Collapse outputs just one string.  sep will output as many strings as you started with.

#### 14.2.5.3 Use str_length() and str_sub() to extract the middle character from a string. What will you do if the string has an even number of characters?

An interesting problem.


```r
prob.14.2.5.3 <- c("happy", "sad", "neutral", "even")
str_length(prob.14.2.5.3)
```

```
## [1] 5 3 7 4
```

```r
str_length(prob.14.2.5.3)/2
```

```
## [1] 2.5 1.5 3.5 2.0
```

```r
str_sub(prob.14.2.5.3, 
        (str_length(prob.14.2.5.3)/2 + 0.5),
        (str_length(prob.14.2.5.3)/2 + 0.5))       
```

```
## [1] "p" "a" "t" "v"
```
So I just took the first of the two letters in the middle of a word with even # of characters

#### 14.2.5.4 What does str_wrap() do? When might you want to use it?


```r
?str_wrap()
```

This is a way to form paragraphs from words.  


```r
s <- c("Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin", "nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel", "lorem. Etiam pellentesque aliquet tellus.")

str_c(s, collapse = "")  # all in one line
```

```
## [1] "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proinnibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vellorem. Etiam pellentesque aliquet tellus."
```

```r
str_wrap(s, width = 1) # new line break between each word
```

```
## [1] "Lorem\nipsum\ndolor\nsit\namet,\nconsectetur\nadipisicing\nelit.\nProin"    
## [2] "nibh\naugue,\nsuscipit\na,\nscelerisque\nsed,\nlacinia\nin,\nmi.\nCras\nvel"
## [3] "lorem.\nEtiam\npellentesque\naliquet\ntellus."
```

```r
str_wrap(s, width = 100) 
```

```
## [1] "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin"  
## [2] "nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel"
## [3] "lorem. Etiam pellentesque aliquet tellus."
```

```r
str_wrap(str_c(s, collapse = ""), width = 50) # I can specify the line breaks
```

```
## [1] "Lorem ipsum dolor sit amet, consectetur\nadipisicing elit. Proinnibh augue, suscipit a,\nscelerisque sed, lacinia in, mi. Cras vellorem.\nEtiam pellentesque aliquet tellus."
```

#### 14.2.5.5 What does str_trim() do? What’s the opposite of str_trim()?


```r
?str_trim  #removes whitespace
?str_pad  # adds whitespace; can specify how much space

rbind(
  str_pad("stacey", 20, "left"),
  str_pad("stacey", 20, "right"),
  str_pad("stacey", 20, "both")
)
```

```
##      [,1]                  
## [1,] "              stacey"
## [2,] "stacey              "
## [3,] "       stacey       "
```

```r
ex <-  str_pad("stacey", 20, "left")
ex
```

```
## [1] "              stacey"
```

```r
str_trim(ex, side = "right")
```

```
## [1] "              stacey"
```

```r
str_trim(ex, side = "left")
```

```
## [1] "stacey"
```

#### 14.2.5.6 Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.

This is a bit complicated because I want the output to vary depending on input length
If length = 0, I want to return 0 (or the input)
If length = 1, I want to return the input
If length = 2, I want to return 'a and b'
If length = 3 or more, I want to return 'a, b,  ... 

I think that if length >= 3, I add 


```r
vec <- c("A", "B", "C")
#function for this usage is:

str_c(vec[1:2], collapse = ", ")  
```

```
## [1] "A, B"
```

```r
str_c(str_c(vec[1:2], collapse = ", "), "and", str_c(vec[3], collapse = ", "), sep = " ")
```

```
## [1] "A, B and C"
```

```r
# yow, that is messy.  And very specific
```

Can I generalize using info from this chapter?


```r
vec <- c("A", "B", "C")
len <- length(vec)

#str_c(
#  if (len = 1) "vec",
#  if (len > 1) " and HAPPY BIRTHDAY",
#  "."
#  )

vec <- c("A")
len <- length(vec)
str_c(if (len == 1) vec)
```

```
## [1] "A"
```

```r
# OK, that was fine

vec <- c("A", "B")
len <- length(vec)
str_c(if (len == 1) vec,
      if (len == 2) vec[1] , "and", vec[2], sep = " ")
```

```
## [1] "A and B"
```

```r
# this worked fine

vec <- c("A", "B", "C")
len <- length(vec)
str_c(if (len == 1) vec,
      if (len == 2) vec[1] , "and", vec[2], 
      if (len == 3) vec[1:2] , "and", vec[3])
```

```
## [1] "andBAandC" "andBBandC"
```

```r
# but this is unexpected.
# I see - it is recycling 'and' and 'C'
```

Not very good.  Will see what others come up with.

# on-line tutorial https://regexone.com/

try to match the WHOLE line(s) of text 

1  abc
2  123.  or, \d\d\d, or [0-9]+

The dot
3 ...\.  
4 [cmf]an
5 [^b]og

character ranges
6  [A-C]\w\w  or [A-C][n-p][a-c]

zzzzzzz's
7  waz{3,5}up

Kleene
8  a*[b-c]+

optionality
9  \d+ files? found\?

white space
10   \d\.\s+[a-c]+

limits
11  ^Mission: successful$

match groups
12   ^(file_.+)\.pdf$  or ^(file.+)\.pdf$

nested groups
13 ^(\w+\s(\d+))$

more groups
14   (\d{4})x(\d{3,4}) or (\d+)x(\d+)

conditional
15  I love cats|dogs

other special characters
16  ^The.+\.$
or  ^.*$

# RegexOne Practice Problems
https://regexone.com/problem/matching_decimal_numbers


### 1.   -?\d+,?\.?\d+\.?e?\d+$

    ^-?\d+(,\d+)*(\.\d+(e\d+)?)?$
is suggested by answer key

### 2.  \(?1?\s?(\d{3})\)?-?\s?\d{3}-?\s?\d{4}
another mess.

 1?[\s-]?\(?(\d{3})\)?[\s-]?\d{3}[\s-]?\d{4}
is suggested by site

my revised version
1?[\(1\s]?(\d{3})[-\)\s]?\d{3}[\s-]?\d{4}
not much prettier

### 3. emails

(\w+\.?\w+)\W\w+@?.+

The actual answer is simpler; only needed to capture name
^([\w\.]*)
([\w.]*)  also seems to work, though not sure why I don't need to escape that '.'

### 4. HTML

^<(a|div)[>|\s|>].*

answer is simpler:
<(\w+)
^<(a|div)   works also

### 5. Matching filenames

This one is tricky.  Exclude those ending in .tmp or .lock or that don't have .suffix

Maybe easiest to say that I only want those ending in .jpg, .png, or .gif

(\w*).(jpg|png|gif)$

key suggests
(\w+)\.(jpg|png|gif)$  very close to mine

### 6. Trimming whitespace

^\s*([\w\s]+\W+)
or 
^\s*(.*)\s*$  Makes sense

### 7. extract from a log file

I want to capture things after widget.List. and before the (
I also want to capture what is within the ()

widget.List.(\w+)\((\w+\.\w+):(\d+)

or more concisely
widget.List.(\w+)\(([\w+\.]+):(\d+)

suggested:
(\w+)\(([\w\.]+):(\d+)\)

### 8. extracting from a URL

(\w+)://([\w_\-\.]+):?(\d*)

suggested answer
(\w+)://([\w\-\.]+)(:(\d+))?  
## why don't they need to specify the underscore? And looks like they captured the :digit, not just digits

# 14.3.1


```r
library(tidyverse)
library(stringr)
x <- c("apple", "banana", "pear")
str_view(x, "an")
```

<!--html_preserve--><div id="htmlwidget-7f245f154aa3cf9fb4ad" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-7f245f154aa3cf9fb4ad">{"x":{"html":"<ul>\n  <li>apple<\/li>\n  <li>b<span class='match'>an<\/span>ana<\/li>\n  <li>pear<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
dot <- "\\."
dot
```

```
## [1] "\\."
```

```r
writeLines(dot)
```

```
## \.
```

# 14.3.5  Grouping and backreferences


```r
?fruit
str_view(fruit, "(..)\\1", match = T)
```

<!--html_preserve--><div id="htmlwidget-bbedf4a3fa5363053e2d" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-bbedf4a3fa5363053e2d">{"x":{"html":"<ul>\n  <li>b<span class='match'>anan<\/span>a<\/li>\n  <li><span class='match'>coco<\/span>nut<\/li>\n  <li><span class='match'>cucu<\/span>mber<\/li>\n  <li><span class='match'>juju<\/span>be<\/li>\n  <li><span class='match'>papa<\/span>ya<\/li>\n  <li>s<span class='match'>alal<\/span> berry<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## 14.3.5.1  What will these expressions match?

1.  (.)\1\1    Maybe any 4 letters in a row?  (why no quotes? Just a typo?)


```r
y <- c("aa1aaaabcd", "qwerty")
#  str_view(y, "(.)\1\1") # why doesn't this work?
str_view(y, "aaa") # that worked
```

<!--html_preserve--><div id="htmlwidget-1f23e698cdb878b764a0" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-1f23e698cdb878b764a0">{"x":{"html":"<ul>\n  <li>aa1<span class='match'>aaa<\/span>abcd<\/li>\n  <li>qwerty<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

2.  "(.)(.)\\2\\1"
I'd expect the \\2 to be 2nd capture group.  so maybe it would be abba ?


```r
y <- c("abbadabba", "anna")
str_view(y,  "(.)(.)\\2\\1") # that worked as expected
```

<!--html_preserve--><div id="htmlwidget-187c81d63e3ca23845df" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-187c81d63e3ca23845df">{"x":{"html":"<ul>\n  <li><span class='match'>abba<\/span>dabba<\/li>\n  <li><span class='match'>anna<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

3. (..)\1
A string of any 4 letters? (answer key: any pair of chracters, twice)

```r
y <- c("aaaaaabcd", "qwerty")
str_view(y, "(..)\1")  # nope; should have worked, though
```

<!--html_preserve--><div id="htmlwidget-6cb22545365cb093176c" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-6cb22545365cb093176c">{"x":{"html":"<ul>\n  <li>aaaaaabcd<\/li>\n  <li>qwerty<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
y <- c("a1a1a1bcd", "qwerty")
#  str_view(y, (..)\1) 
```

4.  "(.).\\1.\\1"
should be something like a.aa (character, anything, character twice more)


```r
y <- c("babbaboo", "qwerty")
str_view(y, "(.).\\1.\\1")
```

<!--html_preserve--><div id="htmlwidget-590bd4421add31ed0275" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-590bd4421add31ed0275">{"x":{"html":"<ul>\n  <li>babbaboo<\/li>\n  <li>qwerty<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# missed the dot in there

y <- c("babbbaboo", "qwerty" ,"babLbaboo")
str_view(y, "(.).\\1.\\1")
```

<!--html_preserve--><div id="htmlwidget-90ca89c99020ce531da1" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-90ca89c99020ce531da1">{"x":{"html":"<ul>\n  <li><span class='match'>babbb<\/span>aboo<\/li>\n  <li>qwerty<\/li>\n  <li><span class='match'>babLb<\/span>aboo<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

5. "(.)(.)(.).*\\3\\2\\1"

The * means 0 or more times.  So anything should match?

```r
y <- c("make111111ekal", "make111ekal" ,"makeekal")
str_view(y, "(.)(.)(.).*\\3\\2\\1")
```

<!--html_preserve--><div id="htmlwidget-ed7bc46888bab52ead88" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-ed7bc46888bab52ead88">{"x":{"html":"<ul>\n  <li>m<span class='match'>ake111111eka<\/span>l<\/li>\n  <li>m<span class='match'>ake111eka<\/span>l<\/li>\n  <li>m<span class='match'>akeeka<\/span>l<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## 14.3.5.2  construct regular expressions to match words that:

1.  start and end with the same letter


```r
z <- c("madam", "solitude", "solas", "session")

str_view(z, "^(.).*\\1$")
```

<!--html_preserve--><div id="htmlwidget-3a050027ef9048986b1c" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-3a050027ef9048986b1c">{"x":{"html":"<ul>\n  <li><span class='match'>madam<\/span><\/li>\n  <li>solitude<\/li>\n  <li><span class='match'>solas<\/span><\/li>\n  <li>session<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

2. Contain a repeated pair of letters (e.g. “church” contains “ch” repeated twice.)


```r
z <- c("chichon", "abracadabra", "attitude") # what will it do with 2 pairs?

str_view(z, "(..).*\\1")
```

<!--html_preserve--><div id="htmlwidget-a3d8e22d7b4b18b34b08" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-a3d8e22d7b4b18b34b08">{"x":{"html":"<ul>\n  <li><span class='match'>chich<\/span>on<\/li>\n  <li><span class='match'>abracadab<\/span>ra<\/li>\n  <li>attitude<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# only takes the first pair of letters

z <- c("chichon", "alracacabra", "attitude") # what will it do with 2 pairs?

str_view(z, "(..).*\\1")
```

<!--html_preserve--><div id="htmlwidget-b714a615767fae454190" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-b714a615767fae454190">{"x":{"html":"<ul>\n  <li><span class='match'>chich<\/span>on<\/li>\n  <li>al<span class='match'>racacabra<\/span><\/li>\n  <li>attitude<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

3. Contain one letter repeated in at least three places (e.g. “eleven” contains three “e”s.)


```r
z <- c("mississippi", "horror", "abstractitive")

str_view(z, "(.).*\\1.*\\1")
```

<!--html_preserve--><div id="htmlwidget-49e16021d0710c86761a" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-49e16021d0710c86761a">{"x":{"html":"<ul>\n  <li>m<span class='match'>ississippi<\/span><\/li>\n  <li>ho<span class='match'>rror<\/span><\/li>\n  <li>abs<span class='match'>tractit<\/span>ive<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## [OPTIONAL] The beginner crosswords at https://regexcrossword.com/  (See https://regexcrossword.com/howtoplay for how to play)






