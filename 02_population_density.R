install.packages("spatstat")
library(spatstat)
bei

 plot(bei)
 
 plot(bei, cex=.2)
 
 plot(bei, cex=.2, pch=19)
 
 bei.extra


 plot(bei.extra)
 elevation = bei.extra[[1]]
 plot(elevation2)

 plot(elevation)
 
 elevation2 = bei.extra[[1]]
 plot(elevation2)
 
 densitymap = density(bei)
 plot(densitymap)
 points(bei, cex=.2)
 
 par(mfrow=c(1,2))
 
 plot(elevation2)
 plot(densitymap)
 
 par(mfrow=c(2,1))
 plot(elevation2)
 plot(densitymap)
 
 dev.off()
null device 
          1 
> plot(elevation2)
> 

> cl =colorRampPalette(c("red", "orange", "yellow"))(3)
> plot(densitymap, col=cl)
> 
> cl = colorRampPalette(c("red", "orange", "yellow"))(10)
> 
> plot(densitymap, col=cl)
> 
> cl =colorRampPalette(c("red", "orange","yellow"))(100)
> plot(densitymap, col=cl)
> 
> cln = colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
> 
> plot(densitymap, col=cln)
> 
> par(mfrow=c(1,2))
> 
> cln = cln = colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
> plot(densitymap, col=cln)
> 
> clg <- colorRampPalette(c("green4", "green3", "green2", "green1", "green"))(100)
> plot(densitymap, col=cln)
> plot(densitymap, col=clg)
> 
> par(mfrow=c(1,2))
> cln = cln = colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
> 
> plot(densitymap, col=cln)
> 
> clg <- colorRampPalette(c("green4", "green3", "green2", "green1", "green"))(100)
> plot(densitymap, col=clg)
> 
> dev.off()
