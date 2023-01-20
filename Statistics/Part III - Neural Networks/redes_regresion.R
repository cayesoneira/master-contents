library(RSNNS)
library(NeuralNetTools)
# create a sample x vs y whose theta is uniform
# r defined around a reference scanned from 5 to 20 with a noise N(0,sig) 
n=1000
sig=1
r0=seq(5,20,by=15/n)
r=rnorm(n,r0,sig)
th=runif(n,0,2*pi)
x=r*cos(th)
y=r*sin(th)
r0=r0[1:n]
targ=(r0-5)/15 #translate target into 0-1 range
plot(x,y)
readline(prompt="Press [enter] to continue")
hist(sqrt(x^2+y^2))
readline(prompt="Press [enter] to continue")
# create a labelled data frame, vars and target r0
trai=data.frame(x,y,targ)
colnames(trai)=c("x","y","tr")
# some operations to mix classes
nc=ncol(trai)
trai=trai[sample(1:nrow(trai),length(1:nrow(trai))),1:nc]
Values <- trai[,1:nc-1]
Targets <- trai[,nc]
# split 15% of the sample for test
trai <- splitForTrainingAndTest(Values, Targets, ratio=0.15)
str(trai)
# size defines the topology size=n one hidden with n neurons, size=c(n,m,s), three layers with n,m,s
# outputActFunc, activation function
# learnFunc learning type with learnFuncParams defining the parameter(s) i.e. learning rate, momentum
# maxit number of iterations 
#http://www.ra.cs.uni-tuebingen.de/SNNS/UserManual/node52.html
model <- mlp(trai$inputsTrain,trai$targetsTrain,size=20,
             inputsTest = trai$inputsTest, targetsTest = trai$targetsTest,
             outputActFunc = "Act_Logistic",
#             learnFunc = "Std_Backpropagation",learnFuncParams = c(0.1),
             learnFunc = "BackpropMomentum",learnFuncParams = c(0.1,0.1), 
#             learnFunc = "SCG", learnFuncParams = c(0.1),
              maxit = 2000)
summary(model)
plotnet(model)
readline(prompt="Press [enter] to continue")
plotIterativeError(model)
readline(prompt="Press [enter] to continue")
#check regression, target vs output
plot(trai$targetsTrain,model$fitted.values) 
readline(prompt="Press [enter] to continue")
attributes(model)
# build a 2D heat map with the prediction, predict
xn=seq(-15,15,by=0.2)
yn=seq(-15,15,by=0.2)
out=outer(xn,yn,function(x,y){predict(model,data.frame(x,y))})
filled.contour(xn,yn,out,color=heat.colors)
readline(prompt="Press [enter] to continue")
#check that extrapolation does not work
yn=runif(1e3,-50,50)
xn=runif(1e3,-50,50)
plot(sqrt(xn^2+yn^2),predict(model,data.frame(xn,yn)))

