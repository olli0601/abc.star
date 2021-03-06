#' @useDynLib abc.star

NABC.DEFAULT.ANS<- {tmp<- c(0, 50, 1, NA, NA, NA, 0, 0, 0, 0, 0, 1, 1, 1, NA, NA, NA); names(tmp)<- c("lkl", "error", "pval","link.mc.obs","link.mc.sim", "rho.mc", "cil", "cir","tl","tr","al","ar","pfam.pval","ts.pval","nsim","mx.pow","rho.pow"); tmp}

.onAttach <- function(...) 
{
	packageStartupMessage("abc.star 1.0.2\nCalibration procedures for accurate ABC\nhttps://github.com/olli0601/abc.star\nO Ratmann; A Camacho; TJ McKinley; S Hu; C Colijn")
}

#------------------------------------------------------------------------------------------------------------------------
# Multiple assignment operatior - Generic form
'%<-%' = function(l, r, ...) UseMethod('%<-%')
# Binary Operator
'%<-%.lbunch' = function(l, r, ...) {
	Envir = as.environment(-1)
	
	if (length(r) > length(l))
		warning("RHS has more args than LHS. Only first", length(l), "used.")
	
	if (length(l) > length(r))  {
		warning("LHS has more args than RHS. RHS will be repeated.")
		r <- extendToMatch(r, l)
	}
	
	for (II in 1:length(l)) {
		do.call('<-', list(l[[II]], r[[II]]), envir=Envir)
	}
}
#------------------------------------------------------------------------------------------------------------------------
# Used if LHS is larger than RHS
extendToMatch <- function(source, destin) {
	s <- length(source)
	d <- length(destin)
	
	# Assume that destin is a length when it is a single number and source is not
	if(d==1 && s>1 && !is.null(as.numeric(destin)))
		d <- destin
	
	dif <- d - s
	if (dif > 0) {
		source <- rep(source, ceiling(d/s))[1:d]
	}
	return (source)
}
#------------------------------------------------------------------------------------------------------------------------
# Grouping the left hand side
g = function(...) {
	List = as.list(substitute(list(...)))[-1L]
	class(List) = 'lbunch'
	return(List)
}
#------------------------------------------------------------------------------------------------------------------------
#' @title Test if summary values are normally distributed
#' @export
#' @param x 			summary values
#' @param normal.test 	name of function with which normality of the summary values is tested
#' @return p value of the test
#' @examples abccheck.normal(rnorm(1e4),"shapiro.test")
abccheck.normal<- function(x,normal.test)
{
	if(!normal.test%in%c("shapiro.test","lillie.test","cvm.test","ad.test","pearson.test","sf.test"))		
		stop("abccheck.normal: error at 1a")	
	ifelse(	any(diff(x)>0), 
			ifelse(normal.test%in%c("shapiro.test","sf.test") && length(x)>5000, 
					eval(call(normal.test,x[1:5000]))$p.value, 
					eval(call(normal.test,x))$p.value), 
			0)
}
###############################################################################
package.mkdir<-function(root,data.name)
{
	if(length(dir(root,pattern=paste('^',data.name,'$',sep='')))==0)
		system(paste("mkdir ",paste(root,data.name,sep='/'),sep=''))
}
###############################################################################
package.dumpframes<- function()
{
	geterrmessage()
	dump.frames()
	cat(paste("\npackage.dumpframes dump 'last.dump' to file",paste(DATA,paste("debug_",paste(strsplit(date(),' ')[[1]],collapse='_'),".rda\n",sep=''),sep='/')))
	save(last.dump, file=paste(DATA,paste("debug_",paste(strsplit(date(),' ')[[1]],collapse='_'),".rda",sep=''),sep='/'))
	q()
}
###############################################################################
package.roxygenize<- function()
{
	roxygenize(CODE.HOME)
}
#------------------------------------------------------------------------------------------------------------------------
histo2<- function(x, theta, nbreaks= 20, breaks= NULL, width= 0.5, plot=0, rtn.dens=0,...)
{
	#compute break points sth theta is in the middle
	if(is.null(breaks))
	{
		breaks<- c(range(x), max(abs( theta - x ))*1.1 / nbreaks)								
		breaks<- c(rev(seq(from= theta-breaks[3]/2, to=breaks[1]-breaks[3], by=-breaks[3] )), seq(from= theta+breaks[3]/2, to=breaks[2]+breaks[3], by=breaks[3] ) )		
	}
	ans.h<- hist(x, breaks=breaks, plot= 0)
	ans.h[["mean"]]<- mean(x)		
	ans.h[["hmode"]]<- mean(ans.h[["breaks"]][seq(which.max(ans.h[["counts"]]),length.out=2)])	
	tmp<- density(x, kernel="biweight",from=breaks[1],to=breaks[length(breaks)],width = max(EPS,width*diff(summary(x)[c(2,5)])))
	ans.h[["dmode"]]<- tmp[["x"]][which.max( tmp[["y"]])]
	if(rtn.dens)
		ans.h[["dens"]]<- tmp
	if(plot)
	{
		plot(ans.h, freq=0,...)
		lines(tmp)
	}
	ans.h
}
###############################################################################
my.fade.col<-function(col,alpha=0.5)
{
	return(rgb(col2rgb(col)[1]/255,col2rgb(col)[2]/255,col2rgb(col)[3]/255,alpha))
}
###############################################################################
print.v<- function(x,cut=3,digits=4,prefix= "simu_",print.char= TRUE, as.R= TRUE)
{
	if(as.R)
	{
		tmp<- paste("c(",paste(c(x,recursive=T),collapse=',',sep=''),')',sep='')
		if(!is.null(names(x)))
			tmp<- paste("{tmp<-", tmp, "; names(tmp)<- ", paste('c("',paste(c(names(x),recursive=T),collapse='", "',sep=''),'")',sep=''), "; tmp}", sep= '', collapse= '')
	}
	else
	{
		if(!is.null(names(x)))
		{
			m<- matrix(NA,nrow=2,ncol=length(x))
			m[1,]<- substr(names(x),1,cut)
			m[2,]<- round( x, digits=digits )
			if(cut==0)		m<- m[2,]
			tmp<- gsub('.',',',paste(prefix,paste(as.vector(m), collapse='_',sep=''),sep=''),fixed=T)
		}
		else
			tmp<- gsub('.',',',paste(prefix,paste(round( x, digits=digits ), collapse='_',sep=''),sep=''),fixed=T)
	}
	if(print.char) print(tmp)
	tmp
}