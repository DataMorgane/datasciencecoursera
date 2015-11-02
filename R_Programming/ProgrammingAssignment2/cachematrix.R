## This functions cache the inverse of a matrix by creating a special
## object CacheMatrix, computing the inverse and storing it in a cache.


## This functions create a special object CacheMatrix that contains
## functions to get and set the value of the matrix, and get and set
## the value of its inverse.
makeCacheMatrix <- function(x = matrix()) {
      # Create a CacheMatrix object
      # Return a list of functions :
      # - set :         set the value of the matrix
      # - get :         get the value of the matrix
      # - setinverse :  set the inverse of the matrix
      # - getinverse :  get the inverse of the matrix
      
      # Initializing the inverse (attribute i) to NULL
      i <- NULL
      
      # Function setting the value of the matrix
      # The  matrix (attribute x) takes the value y
      # The inverse (attribute i) is initialized to NULL
      set <- function(y) {
            x <<- y
            i <<- NULL
      }
      
      # Function getting the value of the matrix
      # The function returns the matrix x (attribute x)
      get <- function() {
            x
      }
      
      # Function setting the value of the inverse
      # The inverse (attribute i) takes the value inv
      setinverse <- function(inv) {
            i <<- inv
      }
      
      # Function getting the value of the inverse
      # It returns the inverse (attribute i)
      getinverse <- function() {
            i
      }
      
      # The function returns a list of all the functions
      # set, get, setinverse, getinverse
      list(set = set, get = get,
           setinverse = setinverse,
           getinverse = getinverse)

}


## This function returns the inverse of a CacheMatrix. If its inverse
## is already stored in the cache, it returns this value. Else, it
## computes the inverse, return it, and store it in the cache.
cacheSolve <- function(x, ...) {
      # Return a matrix that is the inverse of the matrix x
      
      # The value of the cached inverse is stored in i
      i <- x$getinverse()
      
      # If the value of the cached inverse is not NULL (ie it exists)
      # the function returns it
      if(!is.null(i)) {
            message("getting cached data")
            return(i)
      }
      
      # Getting the value of the matrix x and storing it in data
      data <- x$get()
      
      # Computing the inverse of data
      i <- solve(data, ...)
      
      # Setting the inverse in x (so it can be accessed later)
      x$setinverse(i)
      
      # Returning the inverse
      i
      
}









