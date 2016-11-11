a <- c(1, 2, FALSE, "hello")

class(a)


c(1, 2, 3) + c(1, 2, 3)


# 
# Here, in each repetition of the for loop, R has to re-size 
# the vector and re-allocate memory. It has to find the vector 
# in memory, create a new vector that will fit more data, copy the old data 
# over, insert the new data, and erase the old vector. This can get 
# very slow as vectors get big.
j <- 1
for (i in 1:10) {
  j[i] = 10
}

j

# 
# If one pre-allocates a vector that fits all the values, R doesn’t 
# have to re-allocate memory each iteration, and the results can be much faster. 
# Here’s how you’d do that for the above case:

j <- rep(NA, 10)
for (i in 1:10) {
  j[i] = 10
}
j

library(microbenchmark)

x <- runif(100)

x

microbenchmark(
  sqrt(x),
  x ^ 0.5
)

x = runif(100)
my.log1 <- function(x){
  y <- numeric( length(x) )
  for(i in 1:length(x)){
    y[i] <- log(x[i])
  }
  return(y)
}
my.log2 <- function(x){
  y <- log(x)
  return(y)
}

microbenchmark(my.log1(x),my.log2(x))



# Write a for loop to create a vector containing the first 10 powers of 3. 
# Pre-allocate the memory you will use. (Hint: See slide 17 of the “Efficient Coding in R” PowerPoint.)
# What is the last entry in your vector?

x = seq(1,10)
x

for(i in 1:10){
  x[i] = 3^i
  }
x[10]

y = seq(1,10)
x = 3^y
x



#####################################
Powers.of.3.for.loop <- function(){
  x = numeric(10)
  x[1] = 3
  for(i in 2:10){
    x[i] = 3*x[i-1]
  }
  return(x)
}
Powers.of.3.vector <- function(){
  my.ints = 1:10
  x = 3^my.ints
  return(x)
}
microbenchmark( Powers.of.3.for.loop(), Powers.of.3.vector() )

ames = read.csv("AmesHousing.csv")
ames2 = as.matrix(ames)

j = 1
y = matrix( , nr = 2930, nc=82 )
num.rows = dim(ames2)[1]
for(i in 1:num.rows){
  quality = ames2[ i, c(32,42,55) ]
  quality = quality[ !is.na(quality) ]
  at.least.one.Excellent = any( quality == "Ex" )
  if( at.least.one.Excellent ){
    y[j,] = ames2[i,]
    j = j + 1
  }
}

ames_subset = y[ 1: (j-1), ]
ames_subset[1,c(32,42,55)]
dim(ames_subset)


?system.time