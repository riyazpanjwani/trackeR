##Gives the List of Commits given path and number of commits
#Data frame stores the SHA1 Values
list_commits <- function(path = "./", num_commits = 10){
  stopifnot(is.character(path))
  stopifnot(length(path) == 1)
  stopifnot(is.numeric(num_commits))
  stopifnot(length(num_commits) == 1)

  target <- git2r::repository(path)
  commit_list <- git2r::commits(target, n = num_commits)
  #Making it more user friendly :D
  sha_list <- list() #Store SHA1 Values
  msg_list <- list() #Store Assosiated Message
  date_list <- list() #Store Date
  sum_list<-list()#Store Summary
  for (i in 1:num_commits) {
    sha_list[i] <- as(commit_list[[i]]@"sha","character")
    sum_list[i] <-as(commit_list[[i]]@"summary","character")
    date_list[i] <-as(commit_list[[i]]@committer@when,"character")
    msg_list[i]<-as(commit_list[[i]]@message,"character")

  }
  #Go to master branch
  git2r::checkout(target,"master")
  as.data.frame(cbind(sum_list,msg_list,date_list,sha_list),stringAsFactors=F)
  #str(sha)
}



##Helper Functions
find_sha<-function(val_commit){
  stopifnot(git2r::is_commit(val_commit))

  attr(val_commit,which="sha")
}

find_time<-function(val_commit){
  stopifnot(git2r::is_commit(val_commit))

  methods::as((val_commit@committer@when),"POSIXct")
}

find_msg<-function(val_commit){
  stopifnot(git2r::is_commit(val_commit))

  base::substr(val_commit@message,start=1,stop=50)
}

find_summary<-function(val_commit){
  stopifnot(git2r::is_commit(val_commit))

  base::substr(val_commit@summary,start=1,stop=50)
}
#Test time for a paticular test file (in tests/testthat dir) against  a
#paticular commit in the git repo

test_time_commit<-function(test_path="./",test_commit){
  stopifnot(is.character(test_path))
  stopifnot(length(test_path)==1)
  stopifnot(!is.null(test_commit))
  stopifnot(git2r::is_commit(test_commit))

  #get the whole structure of Commit
  sha_val<-find_sha(test_commit)
  msg_val<-find_msg(test_commit)
  mod_time<-find_time(test_commit)
  sum_val<-find_summary(test_commit)

  org_lines<-readLines(test_path)
  test_lines<-readLines(test_path)
  #fixed is been maintained TRUE since we don't match Regex
  test_lines<-sub("test_that","testme",test_lines,fixed=TRUE)
  #Allows to load and attach testthat file iff not attached
  concat_string <- "if(requireNamespace(\"testthat\", quietly = TRUE)) {
  require(testthat)\n }\n"
  test_lines<-c(concat_string,test_lines)
  org_lines<-c(concat_string,org_lines)
  temp<-tempfile()
  temp_file_original<-tempfile()
  writeLines(test_lines,temp)
  writeLines(org_lines,temp_file_original)


  #setwd() to the root dir of the package
  path="/home/riyaz/forkedPackages/stringr"
  target<-git2r::repository(path)
  git2r::checkout(test_commit)
  on.exit(expr=git2r::checkout(target,"master"))
  #Parse in the gven environment
  #source(temp,local=T)
  #readLines(temp)



#----------Coding begins here---------
#this project is basic one
test.results <- list()
test.repetitions <- 3

#Kuch karna hai
#Iss bhai ke vajhese bc meri G Fat Gayi chohatar hogayi ;)

path="/home/riyaz/forkedPackages/stringr"
suppressPackageStartupMessages(devtools::load_all(file.path(path)))

f_status="Success"
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


  time.df <- data.frame(test.name, MeasuredParam="seconds",status=test_status,
                        MeasuredVal=seconds,message=msg_val,date_time=mod_time,
                        summary=sum_val)
  test.results[[test.name]] <<- time.df
}
source(temp,local=T)
#----------------------------------------------------------------
  #library(ggplot2)
  #g<-ggplot(time.df,aes(test.name,seconds))
  #g+geom_point()
 # -----------------------------------------------------------------
  #Format the Op
  test.results.df<-do.call(rbind,test.results)
#base name is used to get the file name tested
test.results.df <- rbind(test.results.df, data.frame(test.name = basename(test_path),
                                                     MeasuredParam = "seconds", status = f_status,
                                                     MeasuredVal = seconds_file, message = msg_val,
                                                     date_time = mod_time,summary=sum_val))

rownames(test.results.df) <- NULL
write.table(test.results.df, "/home/riyaz/data/R/excelplot1.txt", sep="\t")
#test.results.df

}
