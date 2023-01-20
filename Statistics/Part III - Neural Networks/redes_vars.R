library(RSNNS)
library(NeuralNetTools)
# create a sample x vs y whose radius is gaussian and theta uniform
n=1000 # size
sig=1  # spread
muestra1=10 #mean radius sample A 
muestra2=5  #mean radius sample B

r=rnorm(n,muestra1,sig)
th=runif(n,0,2*pi)
r2=rnorm(n,muestra2,sig)
th2=runif(n,0,2*pi)
x=c(r*cos(th),r2*cos(th2))
y=c(r*sin(th),r2*sin(th2))
#two alternative possible distortion of our xample
# transform one coordinate exponentially
x=exp(x)
#increase largely x for a small fraction of the data
#aux=runif(n)
#ifelse(aux<0.01,100*x,x)

plot(x,y) # plot to check
readline(prompt="Press [enter] to continue") #wait enter to continue
hist(sqrt(x^2+y^2)) #radial view
readline(prompt="Press [enter] to continue")
# create a labelled data frame, vars and target (1, 0)
trai=data.frame(x,y,c(rep(1,n),rep(0,n)))
colnames(trai)=c("x","y","tr")
# some operations to mix classes
nc=ncol(trai)
trai=trai[sample(1:nrow(trai),length(1:nrow(trai))),1:nc]
Values <- trai[,1:nc-1]
#Targets <- decodeClassLabels(trai[,nc]) # Internal RSNNS function to illustrate with iris
Targets <- trai[,nc] 
# split 15% of the sample for test
trai <- splitForTrainingAndTest(Values, Targets, ratio=0.15)
#normalize/preprocess
#trai <- normTrainingAndTestSet(trai,type="0_1") # norm 0_1 o center 
str(trai)
# size defines the topology size=n one hidden with n neurons, size=c(n,m,s), three layers with n,m,s
# outputActFunc, activation function
# learnFunc learning type with learnFuncParams defining the parameter(s) i.e. learning rate, momentum
# maxit number of iterations 
#http://www.ra.cs.uni-tuebingen.de/SNNS/UserManual/node52.html
model <- mlp(trai$inputsTrain,trai$targetsTrain,size=c(10,5),
             inputsTest = trai$inputsTest, targetsTest = trai$targetsTest,
             outputActFunc = "Act_Logistic",
#             learnFunc = "Std_Backpropagation",learnFuncParams = c(0.1),
             learnFunc = "BackpropMomentum",learnFuncParams = c(0.1,0.1), 
#             learnFunc = "SCG", learnFuncParams = c(0.1),
              maxit = 500)
summary(model) #summarize results
plotnet(model) #plot the network with weight importance drawn with the line thickness
readline(prompt="Press [enter] to continue")
plotIterativeError(model)   #plots the error function evolution for test and validation
readline(prompt="Press [enter] to continue")
sum(model$fitted.values[Targets==0]>0.5)
plotROC(model$fitted.values,Targets)
readline(prompt="Press [enter] to continue")
attributes(model)
hist(model$fitted.values[Targets==0],col=rgb(1,0,0,0.3))
hist(model$fitted.values[Targets==1],col=rgb(0,0,1,0.3),add=T)
readline(prompt="Press [enter] to continue")
# build a 2D heat map with the prediction, predict
xn=seq(-15,15,by=0.2)
yn=seq(-15,15,by=0.2)
out=outer(xn,yn,function(x,y){predict(model,data.frame(x,y))})
filled.contour(xn,yn,out,color=heat.colors)
readline(prompt="Press [enter] to continue")
