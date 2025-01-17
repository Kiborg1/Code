library(rgl)
library(plot3D)
library(data.table)
library(ggplot2)
library(viridis)
library(gridExtra)
library(fields)

#Sys.setlocale("LC_ALL", "Russian_Russia")

xx = fread("3D ur, uz(x).txt", header = TRUE, dec = ",")
yy = fread("3D ur, uz(y).txt", header = TRUE, dec = ",")
z = fread("3D ur, uz.txt", header = TRUE, dec = ",")
x = xx$x #;xx
y = yy$y

len = length(x)

zl = fread("zlims(real).txt", header = TRUE, dec = ".")
rlim = c(zl[[1]][1], zl[[1]][2])*1.01 
zlim = c(zl[[2]][1], zl[[2]][2])*1.01


#zm = max(abs(z), na.rm = TRUE)
zm = max(abs(rlim))
x1 = x / (max(x) - min(x)) * zm
y1 = y / (max(y) - min(y)) * zm 

zm = max(abs(zlim))
x2 = x / (max(x) - min(x)) * zm 
y2 = y / (max(y) - min(y)) * zm 

ur = matrix(z$ur, nrow = length(x), ncol = length(y), byrow = FALSE)
uz = matrix(z$uz, nrow = length(x), ncol = length(y), byrow = FALSE)

levels = 30

st = readLines("3D ur, uz(title).txt")
st
s = st[[1]]
ss = sub(", t =", ", \n t =", st[[1]])
ss = strsplit(ss, "\n")
s1 = ss[[1]][1]
s2 = ss[[1]][2]


if (as.logical(readLines("MakePDFs.txt")[1])) {
pdf(file = paste("3D ur, uz(title ,", s, ").pdf"), width = 26)
par(mfrow = c(1, 2), cex = 1.0, cex.sub = 1.3, col.sub = "blue")

pp = persp3D(z = ur, x = x1, y = y1, scale = FALSE, zlab = "ur(x,t)",
       contour = list(nlevels = levels, col = "red"),
#zlim = c(urmin, max(urRe, na.rm = TRUE) * 0.3),
        expand = 0.2,
       image = list(col = grey(seq(0, 1, length.out = 100))), main = "ur(x,t)", sub = s1, zlim = rlim)

pp2 = persp3D(z = uz, x = x2, y = y2, scale = FALSE, zlab = "uz(x,t)",
       contour = list(nlevels = levels, col = "red"),
#zlim = c(-40, max(uzRe, na.rm = TRUE) * 0.7),
        expand = 0.2,
       image = list(col = grey(seq(0, 1, length.out = 100))), main = "uz(x,t)", sub = s2, zlim = zlim)

dev.off()
}


png(filename = paste("3D", s, ".png"), width = 1080, height=810,units = "px",res = NA)
par(mfrow = c(2, 2), cex = 1.0, cex.sub = 1.3, col.sub = "blue")
layout(matrix(c(1, 2, 3, 4), 2, 2, byrow = FALSE), widths = c(1.3, 1))

pp = persp3D(z = ur, x = x1, y = y1, scale = FALSE, zlab = "ur(x,t)",
       contour = list(nlevels = levels, col = "red"),
#zlim = c(urmin, max(urRe, na.rm = TRUE) * 0.3),
        expand = 0.2,
       image = list(col = grey(seq(0, 1, length.out = 100))), main = "ur(x,t)", sub = s1, zlim = rlim, clim = rlim)

persp3D(z = uz, x = x2, y = y2, scale = FALSE, zlab = "uz(x,t)",
       contour = list(nlevels = levels, col = "red"),
#zlim = c(-40, max(uzRe, na.rm = TRUE) * 0.7),
        expand = 0.2,
       image = list(col = grey(seq(0, 1, length.out = 100))), main = "uz(x,t)", sub = s2, zlim = zlim, clim = zlim)

image(x, y, abs(ur), col = heat.colors(levels), main = "|ur|")
image(x, y, abs(uz), col = topo.colors(levels), main = "|uz|")

dev.off()



if (FALSE) {
png(filename = paste(s, "(heatmap).png"),height = 600,width = 1000)
par(mfrow = c(1, 2), cex = 1.0, cex.sub = 0.9, col.sub = "blue")
urt <- data.frame(ur.abs = c(abs(z$ur)), x = rep(x, len), y = rep(y, each = len))
p1 = ggplot(urt, aes(x, y, fill = ur.abs)) +
    geom_raster(interpolate = TRUE) +
    coord_fixed(expand = FALSE) +
    scale_fill_viridis()

urz <- data.frame(uz.abs = c(abs(z$uz)), x = rep(x, len), y = rep(y, each = len))
p2 = ggplot(urz, aes(x, y, fill = uz.abs)) +
    geom_raster(interpolate = TRUE) +
    coord_fixed(expand = FALSE) +
    scale_fill_viridis()

    grid.arrange(p1, p2, ncol = 2, top = "|u| values")

dev.off()
}

