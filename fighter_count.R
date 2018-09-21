table <- read.table("fighter.txt")
table2 <- read.table("fighter2.txt")


pdf("fighter_count.pdf")

layout(matrix(c(1,1,2,2),2,2,byrow=T))
matplot(table2,type='l')
barplot(table$V2, names.arg=(table$V1),ylab="number of competiors")
dev.off()
