#----------Coding begins here---------
#this project is basic one
test.results <- list()
test.repetitions <- 3
time.df<-data.frame()
testme<- function(test.name, code){
  e <- parent.frame()
  code.subs <- substitute(code)
  run <- function(){
    testthat:::test_code(test.name, code.subs, env=e)
  }
  seconds <- if(require(microbenchmark)){
    times <- microbenchmark(test={
      run()
    }, times=test.repetitions)
    times$time/1e9 #Calculate in ns
  }else{
    replicate(test.repetitions, {
      time.vec <- system.time({
        run()
      })
      time.vec[["elapsed"]]
    })
  }
  time.df <- data.frame(test.name, seconds)
  test.results[[test.name]] <<- time.df
  library(ggplot2)
  g<-ggplot(time.df,aes(test.name,seconds))
  g+geom_point()
}

