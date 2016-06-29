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
