##Gives the List of Commits given path and number of commits
#Data frame stores the SHA1 Values
list_commits <- function(path = "./", num_commits = 20){
  stopifnot(is.character(path))
  stopifnot(length(path) == 1)
  stopifnot(is.numeric(num_commits))
  stopifnot(length(num_commits) == 1)

  target <- git2r::repository(path)
  commit_list <- git2r::commits(target, n = num_commits)
  sha <- character()
  count<-0
  for (i in 1:num_commits) {
    sha[i] <- attr(commit_list[[i]], which = "sha")
  }
  #Go to master branch
  git2r::checkout(target,"master")
  as.data.frame(sha)
  #str(sha)
}
