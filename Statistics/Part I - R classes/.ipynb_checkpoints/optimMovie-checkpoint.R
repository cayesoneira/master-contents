#
# Script to plot the evolution of the 'optim' fitting
#

rm(list=ls())

# Function to wait for secs
waitsecs <- function(x)
{
    p1 <- proc.time()
    Sys.sleep(x)
    proc.time() - p1
}
# Function to fit
funp1p2 <- function(x,p1,p2) {
    n <- length(x)
    f <- numeric(n)
    f <- p1*cos(p2*x)+p2*sin(p1*x)
    return(f)
}

# Read data (must be in same dir than R script)
data <- read.table("./dataOptize.txt", header=TRUE)
xdata <- data[,1]
ydata <- data[,2]
par(xpd=NA) # to permit plotting 'outside' plotting area
# initial plot with data
plot(xdata,ydata,ylim=c(-2,3),xlim=c(-2,3),pch=16,col="magenta")
# some starting values + plot function for this selection
p1_init = 1.0
p2_init = 0.2
xp <- seq(min(xdata),max(xdata),length.out=1000)
yp <- funp1p2(xp,p1_init,p2_init)
lines(xp, yp, col="blue", lty=2)

# Function to minimize
iter = 0
fun.to.minimize <- function(params,x,y) {
    iter <<- iter + 1
    p1 <- params[1]
    p2 <- params[2]
    output <- sum((y-funp1p2(x,p1,p2))^2)
    xp <- seq(-2,3,length.out=100)
    yp1p2 <- funp1p2(xp,p1,p2)  
    # plot the function for every combination of parameters
    lines(xp, yp1p2, col="green", lwd=1) 
    waitsecs(0.3)
    cat("iter=",iter, "\n")
    if (iter>1) {
        # put a white rectangle to hide the title
        rect(xleft=-1.5, ybottom=3.5, xright=3, ytop=4.5,col="white", border=NA)

    }
    # plot title in red
    par(col.main='red')
    title(main=paste("Number of iterations=",iter, sep=""))
    return(output)
}

# using optim(...) to find best fit
solution <- optim(c(p1_init,p2_init), fun.to.minimize, x=xdata, y=ydata)
new.p1 <- solution$par[1]
new.p2 <- solution$par[2]

# plot solution
yp <- funp1p2(xp,new.p1,new.p2)
lines(xp, yp, col="red", lwd=2)
legend("bottomleft",c("initial guess","final fit"),lty=c(2,1),col=c("blue","red"),bty='n',cex=0.8)
