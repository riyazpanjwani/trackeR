time_compare <- function(test_path, num_commits = 10) {
  stopifnot(is.character(test_path))
  stopifnot(length(test_path) == 1)
  stopifnot(is.numeric(num_commits))
  stopifnot(length(num_commits) == 1)
  num_commits <- floor(num_commits)

  path="/home/riyaz/forkedPackages/stringr"
  target <- git2r::repository(path)
  commit_list <- git2r::commits(target, n = num_commits)
  result_list <- list()

  for(commit_i in seq_along(commit_list)){
    one_commit <- commit_list[[commit_i]]
    suppressMessages(result_list[[commit_i]] <- test_time_commit(test_path, one_commit))
  }

  test.results <- do.call(rbind, result_list)
  test.results
}
