## ----results='asis'-----------------------------------------------------------
set.seed(123)
n<-1e7
x<-(pi/3)*runif(n)
y<-sin(x)*(pi/3)
I<-mean(y)
m<-matrix(c(mean(y),var(y)),1,2)
rownames(m)<-"Simple MC  "
colnames(m)<-c("mean","variance")
p<-knitr::kable(m)
print(p,type="latex")

## ----results='asis'-----------------------------------------------------------
n<-1e7
x1<-(pi/3)*runif(n)
x2<-pi/3-x1
y1<-sin(x1)*(pi/3)
y2<-sin(x2)*(pi/3)
I<-mean(y1+y2)/2
m<-matrix(c(I,var((y1+y2)/2)),1,2)
rownames(m)<-"Control variate  "
colnames(m)<-c("mean","variance")
p<-knitr::kable(m)
print(p,type="latex")

## ----results='asis'-----------------------------------------------------------
n<-1e7
x<-(pi/3)*runif(n)
y<-sin(x)*(pi/3)
a<--cov(x,y)/var(x)
y<-sin(x)*(pi/3)+a*(x-pi/6)
m<-matrix(c(mean(y),var(y)),1,2)
rownames(m)<-"Control variate  "
colnames(m)<-c("mean","variance")
p<-knitr::kable(m)
print(p,type="latex")

## ----results='asis'-----------------------------------------------------------
n<-1e7
x1<-runif(n)
y1<-exp(-x1)/(1+x1^2)
I<-mean(y1)
m<-matrix(c(I,var(y1)),1,2)
rownames(m)<-"Simple MC  "
colnames(m)<-c("mean","variance")
p<-knitr::kable(m)
print(p,type="latex")

## ----results='asis'-----------------------------------------------------------
library(scales)
n<-1e7
x1<-runif(n/2)
x2<-1-x1
y1<-exp(-x1)/(1+x1^2)
y2<-exp(-x2)/(1+x2^2)
I<-mean(y1+y2)/2
m<-matrix(c(I,var((y1+y2)/2)),1,2)
rownames(m)<- "Antithetic variables"
colnames(m)<-c("mean","variance")
p<-knitr::kable(m)
print(p,type="latex")

## -----------------------------------------------------------------------------
n<-1e5
K<-5
N<-1000
Y<-numeric(K)
est <-matrix(0, N, 2)
F<-function(k,K) 
  {   
    return(c((1-exp(-(k-1)/5))/(1-exp(-1)),(1-exp(-k/K))/(1-exp(-1))))
}
for(j in 1:N){
  x<--log(1-(1-exp(-1))*runif(n))
  y<-(1-exp(-1))/(1+x^2)
for (i in 1:K){
  u<-runif(n*(F(i,K)[2]-F(i,K)[1]))
  u1<-u*(F(i,K)[2]-F(i,K)[1])+F(i,K)[1]
  x1<--log(1-(1-exp(-1))*u1)
  y1<-(F(i,K)[2]-F(i,K)[1])*(1-exp(-1))/(1+x1^2)
  Y[i]<-mean(y1)
}
  est[j,1]<-mean(y)
  est[j,2]<-sum(Y)
}


## ----results='asis'-----------------------------------------------------------
m<-matrix(nrow=2,ncol=2)
m[1,]<-apply(est,2,mean)
m[2,]<-apply(est,2,sd)
colnames(m)<-c("Importance sampling","Stratified importance sampling")
rownames(m)<-c("mean","standard error")
p<-knitr::kable(m)
print(p,type="latex")

## -----------------------------------------------------------------------------
set.seed(1234)
n<-1e6
u<-runif(n)
x1<-sqrt(-2*log((1-u)/exp(1/2)))
x2<-(-3*log((1-u)/exp(1/3)))^(1/3)
y1<-x1/(2*pi*exp(1))^(1/2)
y2<-1/((2*pi)^(1/2)*exp(1/3))*exp(x2^3/3-x2^2/2)
I1<-mean(y1)
I2<-mean(y2)
I1
I2
var(y1)
var(y2)

## -----------------------------------------------------------------------------
l<-seq(1,5,0.01)
plot(l,1-exp(1/2-l^2/2),xlab="x",ylab="F(x)",main = paste("CDF of importance functions f1(x)"))

## -----------------------------------------------------------------------------
n<-1e6
K<-3
N<-50
Y<-numeric(K)
est <-matrix(0, N, 2)
F<-function(k) 
  {   
    if(k<=2)  
    return(c(1-exp(1/2-k^2/2),1-exp(1/2-(k+1)^2/2)))   
     else   
    return(c(1-exp(1/2-k^2/2),0.9999))
}
for(j in 1:N){
  x<-sqrt(-2*log((1-runif(n))/exp(1/2)))
  y<-x/(2*pi*exp(1))^(1/2)
for (i in 1:K){
  u<-runif(n*(F(i)[2]-F(i)[1]))
  u1<-u*(F(i)[2]-F(i)[1])+F(i)[1]
  x1<-sqrt(-2*log((1-u1)/exp(1/2)))
  y1<-(F(i)[2]-F(i)[1])*x1/(2*pi*exp(1))^(1/2)
  Y[i]<-mean(y1)
}
  est[j,1]<-mean(y)
  est[j,2]<-sum(Y)
}
apply(est,2,mean)
apply(est,2,sd)

