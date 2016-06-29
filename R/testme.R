#----------Coding begins here---------
#this project is basic one
test.results <- list()
test.repetitions <- 3

#Kuch karna hai

status="Success"
seconds_file <- tryCatch(expr = {
  if(requireNamespace('microbenchmark')){
    times <- microbenchmark::microbenchmark(test = {
      base::source(temp_file_original, local = T)
    }, times = test.repetitions )
    times$time/1e9
  } else {
    replicate(test.repetitions, {
      time.vec <- system.time( {
        source(temp_file_original, local = T)
      } )
      time.vec[["elapsed"]]
    })
  }
},
error = function(e){
  status = "fail"
  NA
}
)

time.df<-data.frame()
testme<- function(test.name, code){
  e <- parent.frame()
  code.subs <- substitute(code)
  #Suggest some alternatve
  run <- function(){
    testthat:::test_code(test.name, code.subs, env=e)
  }
  test_status="pass"

  seconds <-tryCatch(expr = {
    if(requireNamespace('microbenchmark')){
      times <- microbenchmark::microbenchmark(test = {
          run()
      }, times = test.repetitions )
      times$time/1e9
    } else {
      replicate(test.repetitions, {
        time.vec <- system.time( {
           run()
        } )
        time.vec[["elapsed"]]
      })
    }
  },
  error = function(e){
    test_status = "fail"
    NA
  }
  )


  time.df <- data.frame(test.name, metric_name="seconds",test_status,
                    metric_val=seconds,message=msg_val,date_time=mod_time,
                    summary=sum_val)
  test.results[[test.name]] <<- time.df
}
  source(temp,local=T)
----------------------------------------------------------------
  #library(ggplot2)
  #g<-ggplot(time.df,aes(test.name,seconds))
  #g+geom_point()
-----------------------------------------------------------------
  #Format the Op
  test.results.df<-do.call(rbind,test.results)
  #base name is used to get the file name tested
  test.results.df <- rbind(test.results.df, data.frame(test_name = basename(test_path),
                                                       metric_name = "seconds", status = status,
                                                       metric_val = seconds_file, message = msg_val,
                                                       date_time = mod_time,summary=sum_val))



