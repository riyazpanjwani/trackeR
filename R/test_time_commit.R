#Test time for a commit and plot the Results

test_time_commit<-function(test_path="./",test_commit=git2r::commits(repository(test_path))){
  stopifnot(is.character(test_path))
  stopifnot(length(test_path)==1)
  stopifnot(!is.null(test_commit))
  stopifnot(git2r::is_commit(test_commit))

  sha_val<-find_sha(test_commit)
  temp<-tempfile()
  writeLines(readLines(test_path,warn=FALSE),temp)
  #setwd() to the root dir of the package
  target<-git2r::repository(test_path)
  git2r::checkout(test_commit)
  on.exit(expr=git2r::checkout(target,"master"))
  #Parse in the gven environment
  source(temp_file,local=T)
  #readLines(temp)

}
