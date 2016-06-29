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
}
