library(RSNNS)
library(NeuralNetTools)
n=1000
#set.seed(1)
# more complex example with "islands", A and B scattered around alternative nodes on a grid
sig=0.2
x0=sample(seq(0,3,by=1),2*n, replace=T)
y0=sample(seq(0,3,by=1),2*n, replace=T)
x=x0+rnorm(2*n)*sig
y=y0+rnorm(2*n)*sig
t=ifelse(2*floor((x0+y0)/2)==(x0+y0),1,0)
trai=data.frame(x,y,t)
colnames(trai)=c("x","y","tr")
# mix
nc=ncol(trai)
dt=trai[sample(1:nrow(trai),length(1:nrow(trai))),1:nc]
Values <- dt[,1:nc-1]
Targets <- dt[,nc]
# test/validation
trts <- splitForTrainingAndTest(Values, Targets, ratio=0.15)
dt=trts
str(dt)

#model <- mlp(trai[1:2],trai$tr,size=10,outputActFunc = "Act_Logistic",learnFuncParams = c(0.1), maxit = 100)
#http://www.ra.cs.uni-tuebingen.de/SNNS/UserManual/node52.html
model <- mlp(dt$inputsTrain,dt$targetsTrain,size=10,
             inputsTest = dt$inputsTest, targetsTest = dt$targetsTest,
             outputActFunc = "Act_Logistic",
#             learnFunc = "Std_Backpropagation",learnFuncParams = c(0.1),
             learnFunc = "BackpropMomentum",learnFuncParams = c(0.1,0.1), 
#             learnFunc = "SCG", learnFuncParams = c(0.1),
              maxit = 2000)
summary(model)
readline(prompt="Press [enter] to continue")
plotnet(model)
readline(prompt="Press [enter] to continue")
plotIterativeError(model)
readline(prompt="Press [enter] to continue")
plotROC(model$fitted.values,Targets)
readline(prompt="Press [enter] to continue")
xn=seq(-1,4,by=0.1)
yn=seq(-1,4,by=0.1)
out=outer(xn,yn,function(x,y){predict(model,data.frame(x,y))})
xp=dt$inputsTest[,1]
yp=dt$inputsTest[,2]
sa=dt$targetsTest==0
sb=dt$targetsTest==1
xa=xp[sa]
ya=yp[sa]
xb=xp[sb]
yb=yp[sb]
filled.contour(xn,yn,out,color=heat.colors,plot.axes={axis(1);axis(2);grid();lines(xa,ya,type="p");lines(xb,yb,type="p",pch=0)})
readline(prompt="Press [enter] to continue")
A=model$fittedTestValues[sa]<0.5
B=model$fittedTestValues[sa]>0.5
Ab=model$fittedTestValues[sb]<0.5
Bb=model$fittedTestValues[sb]>0.5
plot(xa[A],ya[A],xlim=range(xp),ylim=range(yp),xlab="",ylab="")
lines(xa[B],ya[B],col="red",type="p")
lines(xb[Ab],yb[Ab],pch=0,col="red",type="p")
lines(xb[Bb],yb[Bb],pch=0,type="p")
#efficiency matrix
tA=sum(sa)
tB=sum(sb)
cat(sum(A)/tA,sum(B)/tA,"\n")
cat(sum(Ab)/tB,sum(Bb)/tB,"\n")