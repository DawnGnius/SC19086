vacc1a <- function(age, female, ily) {
  p <- 0.25 + 0.3 * 1 / (1 - exp(0.04 * age)) + 0.1 * ily
  p <- p * if (female) 1.25 else 0.75
  p <- max(0, p)
  p <- min(1, p)
  p
}

vacc1 <- function(age, female, ily) {
  n <- length(age)
  out <- numeric(n)
  for (i in seq_len(n)) {
    out[i] <- vacc1a(age[i], female[i], ily[i])
  }
  out
}

vacc2 <- function(age, female, ily) {
  p <- 0.25 + 0.3 * 1 / (1 - exp(0.04 * age)) + 0.1 * ily
  p <- p * (0.75 + 0.5 * female)
  p[p<0] <- 0
  p[p>1] <- 1
  p
}

## 编译cpp代码，生成函数vacc3
## .cpp 文件的开头必须含有下面两行代码：
##           #include <Rcpp.h>
##           using namespace Rcpp;
## 主函数前需有如下一行代码：
##           // [[Rcpp::export]]

library(Rcpp)
sourceCpp('vacc3.cpp')

# 随机生成数据
n <- 1000
age <- rnorm(n, mean = 50, sd = 10)
female <- sample(c(T, F), n, rep = TRUE)
ily <- sample(c(T, F), n, prob = c(0.8, 0.2), rep = TRUE)

# 测试三个函数的结果是否相同
stopifnot(
  all.equal(vacc1(age, female, ily), vacc2(age, female, ily)),
  all.equal(vacc1(age, female, ily), vacc3(age, female, ily))
)

# 比较三个不同函数运算时间
library(microbenchmark)
microbenchmark(
  vacc1(age, female, ily),
  vacc2(age, female, ily),
  vacc3(age, female, ily))
