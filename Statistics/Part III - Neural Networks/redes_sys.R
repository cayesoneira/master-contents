#examples of systematics
# run after training any model with two variables
i1=trai$targetsTest==0
i2=trai$targetsTest==1
x=trai$inputsTest[i1,1]
y=trai$inputsTest[i1,2]
x2=trai$inputsTest[i2,1]
y2=trai$inputsTest[i2,2]

#increase or decrease one of the variables by 10%
hist(predict(model,data.frame(x,y)),col=rgb(1,0,0,0.5))
hist(predict(model,data.frame(x,1.1*y)),col=rgb(0,1,0,0.3),add=T)
hist(predict(model,data.frame(x,0.9*y)),col=rgb(0,0,1,0.3),add=T)
readline(prompt="Press [enter] to continue")
hist(predict(model,data.frame(x2,y2)),col=rgb(1,0,0,0.5))
hist(predict(model,data.frame(x2,1.1*y2)),col=rgb(0,1,0,0.3),add=T)
hist(predict(model,data.frame(x2,0.9*y2)),col=rgb(0,0,1,0.3),add=T)
readline(prompt="Press [enter] to continue")

