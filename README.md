#trackeR
A simple analysis of your R Code.This is a simple tool for analysing run time of various  R codes. It is a miniproject developed for understanding and utility.

##Abstract
Software testing for production & application systems is paramount for package developers. This is because, the quality of coded package(s) has to be constantly monitored and modified to match user requirements. One of the reasons why R is so successful is a due to a huge variety of packages.  Package testing, being one of the components of package development, ensures that performance metrics such as Scalability, Reliability and Resource usage are desirable. The goal of underling study is to develop an efficient tool for the users of R language to measure “Quantitative Metrics” such as Scalability of the Target package(s).

The result obtained is a data-frame of commits attributes and its run-time measurement. The result can be visualized by a plot, using ggplot2 package. As an example test, the stringr package is tested against its last 2 commits and graph is plotted to obtain the average increase in efficiency.

###Results 
The data frame gives a Quantitative estimation of Run time analysis. Looking at the last 2 test case of the recent and last 2nd commit it can be inferred from the graph that the Runtime is decreased by 28.3% (Second Recent: 0.0511 ns and Recent: 0.398 ns) and the overall average being 30.2% which means that the efficiency increases and hence the modified code is better (when compared in regard to run-time efficiency).

###Output
![Final Plot](/home/riyaz/Downloads/image.png)

