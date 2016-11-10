cars = read.csv("Cars 2005.csv")
attach(cars)
head(cars)
#avoid repetition

MileageLookup = function(m){
  #prints the price and engine size(liters)
  #of any cars with Mileage=m 
  print(Price[which(Mileage==m)]) #this is bad because you are repeating "which" statement
  print(Liter[which(Mileage==m)])
}

MileageLookup(8221)
MileageLookup(9135)

#better way to do it
MileageLookup_opt = function(m){
  #prints the price and engine size(liters)
  #of any cars with Mileage=m 
  m_vector = which(Mileage==m) #use only one "which" statement
  print(Price[m_vector]) 
  print(Liter[m_vector])
}

MileageLookup_opt(8221)
MileageLookup_opt(9135)

#Vector Calculations are better than for loops 
# here is a vector calculation
x = runif(10) #creates a vector of nums between 0 and 1 
# ?runif
typeof(x)
x
y = sqrt(x)
y

##less efficient 
x = runif(10)
y = numeric(10)
for (i in length(x)){
  y[i] = sqrt(x[i])
}
y

# Timing R Code
x = runif(10000000)
system.time(sqrt(x)) #vector calculation goes faster
# user  system elapsed 
# 0.14    0.02    0.16 

mySqRt= function(x){
  for(value in x){
    sqrt(value)
  }
}

system.time(mySqRt(x)) #much slower as using a loop
# user  system elapsed 
# 2.54    0.00    2.54 

#system.time only shows seconds, download microbenchmark
# does nano seconds
install.packages("microbenchmark")
install.packages("plyr","colorspace")
library(microbenchmark)

x = runif(50)
microbenchmark(sqrt(x),mySqRt(x))
# Unit: nanoseconds--> want to concentrate on median time
# expr   min    lq     mean median    uq   max neval
# sqrt(x)   302   303   483.82    303   604  3019   100
# mySqRt(x) 11472 12076 13545.82  12378 12981 28074   100

# Timings Boxplot
timings = microbenchmark(sqrt(x),mySqRt(x))
boxplot(timings,las=1)


#Use existing functions! Most functions in R have been optimized
runif #C and C++ is faster because it is compiled
# 
# Exceptions: 
#   Functions with  many versions or arguments
#   Rcpp package (useful for creating functions your run all the time in C++)

# Plan ahead for memory use 
# increasing the size of the variable -> R needs to find more space
x = 2 
for (i in 2:10){
  x = c(x,2*x[i-1])
}
x

x = numeric(10) #only have to find space for var x, one time (more efficient)
x[1]= 2

for (i in 2:10){
  x[i] = 2*x[i-1]
}
x


#Planning Memory Use 
# Avoid using these loops
# x = c(x,newvalue)
# x = cbind(x, newcolumn)
# x = rbind(x, newrow)

# Good idea to preallocate memory: 
#   -empty vector using numeric(L) or vector(L)
#   -empty matrix using matrix(,nr,nc) nr= number of rows, nc = number of columns


# When Reading Data into R, use nrows
# mydata = read.csv("Cars 2005.csv",nrows=804) #allocate memory
# 
# Profiling Code ->analyzing code for speed and memory usage as it runs
#   target your optimization efforts (only profile code being used
  # many times in the future or was especially inefficient)

# upgrades = have cruise control, leather, or upgraded sound (==1)
# write a function to make a subset of the Cars data 
# containing only cars with at least one upgrade 
findCarsUpgraded = function(x){
  carsUpgraded = x[which(cars$Cruise==1 | cars$Leather==1 | cars$Sound==1)]
}
cars$Price[which(cars$Cruise==1 | cars$Leather==1 | cars$Sound==1)]
findCarsUpgraded(cars)

head(cars)


FindOnes <- function(x){
	# Extracts rows of x with 1's in columns 10-12
	y = NULL
	num.rows = dim(x)[1]
	for( i in 1:num.rows ){
		num.ones = length(which( x[i, 10:12] == 1 ))
		if(num.ones > 0){
			y = rbind( y, x[i,] )
		} # end "if there are ones"
	} # end iteration over rows of xc
	return(y)
} # end function FindOnes

# R profiling Code 
gc() #garbage collection
Rprof("FindOnes.txt")
y = FindOnes(cars)
Rprof(NULL)
summaryRprof("FindOnes.txt")

FindOnes.Fast <- function(x){
	# Extracts rows of x with 1's in columns 10-12
	y = x
	j = 1
	num.rows = dim(x)[1]
	for( i in 1:num.rows ){
		num.ones = length(which( x[i, 10:12] == 1 ))
		if(num.ones > 0){
			y[j,] = x[i,]
			j = j + 1
		} # end "if there are ones"
	} # end iteration over rows of x
	return(y[1:(j-1),])
} # end function FindOnes.Fast

FindOnes.Fast(cars)
