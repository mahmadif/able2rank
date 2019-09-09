# References:
	# [1] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Learning to Rank Based on Analogical Reasoning, Proceedings of the 32th AAAI Conference on Artificial Intelligence (AAAI 2018)

func_Arithmetic <- function(A,B,C,D, type=0){ # covers binary case both for type=0 and type=1
	res <- double(length(A))
	inds <- sign(A-B)==sign(C-D)
    res[inds] <- 1 - abs( (A[inds]-B[inds]) - (C[inds]-D[inds]) )
	if (type==1)
		res[!inds] <- 1 - pmax( abs(A[!inds]-B[!inds]), abs(C[!inds]-D[!inds]) )
    res
}

func_Geometric <- function(A,B,C,D, bin_vec) { # does not cover binary case
	res <- double(length(A)) # all-zero vector
	inds <- sign(A-B)==sign(C-D)
	
	AD <- A*D
	BC <- B*C
	res <- pmin(AD,BC)/pmax(AD,BC)
	res[is.nan(res)] <- 0 # in case of 0/0
	
	bin <- seq_along(A) %in% bin_vec
    res[inds & bin] <- 1 # to cover the binary case
	
	res[!inds] <- 0
	res
}

func_MinMax <- function(A,B,C,D) 1 - pmax( abs( pmin(A,D)-pmin(B,C) ), abs( pmax(A,D)-pmax(B,C) ) ) # covers binary case

func_Approximate <- function(A,B,C,D, tolerance) { # covers binary case both for tolerance=0.05 and tolerance=0.1
	p1 <- abs(A-B)<=tolerance & abs(C-D)<=tolerance 
	p2 <- abs(A-C)<=tolerance & abs(B-D)<=tolerance
	(p1 | p2)*1
}

func_ApproximateGraded <- function(A,B,C,D, bin_vec, tolerance=0.2){ # does not cover binary case
	f_inner <- function(vec1,vec2){
		z <- abs(vec1-vec2)
		a <- replace(z, z>tolerance, 0)
		if (sum(a)==0) return(a)
		
		r <- a/tolerance
		replace(r, r>0, 1-r[r>0])
	}
	inds <- sign(A-B)==sign(C-D)
	
	p1 <- pmin( f_inner(A,B), f_inner(C,D) )
	p2 <- pmin( f_inner(A,C), f_inner(B,D) )
	res <- pmax(p1,p2)
	
	bin <- seq_along(A) %in% bin_vec
    res[inds & bin] <- 1 # to cover the binary case
	res
}

#================== func_APP ==================

# func_APP implements the Analogy-based Pairwise Preferences (APP) algorithm proposed in [1]

# input:
	# train_norm: train data \in [0,1]^d where d is dimension
	# test_norm: test data \in [0,1]^d where d is dimension
	# trnRANK: ranking of the instances in the training data
	# aggregator: the function to extend analogy scores from attributes to feature vectors. 
	# principle: different proposals for measuring analogical proportion listed in Sec. 3.2 in [1]
	# bin: indices of Binary attributes
# output:
	# Given the specified principle, the function returns top_k analogy scores together with the respective (derived) preferences for each pair of instances in the test_norm

func_APP <- function( train_norm, test_norm, trnRANK, aggregator="mean",  principle, bin ){

	f_aggregation <- function(x, aggregator) get(aggregator)(x)

	cmb_train <- combn(nrow(train_norm),2)
	cmb_test <- combn(nrow(test_norm),2)
	ntest <- ncol(cmb_test)
	ntrain <- ncol(cmb_train)
	
	analogy_scores <- double(ntrain)
	prefs <- logical(ntrain)
	
	top_k <- 25
	mat_prefs <- matrix(FALSE, ntest, top_k)
	mat_analogy_scores <- matrix(0, ntest, top_k)

	for( i in 1:ntest ) {

		v <- cmb_test[,i]
		C <- test_norm[ v[1] ,]
		D <- test_norm[ v[2] ,]
		
		for ( j in 1:ntrain ) {
			w <- cmb_train[, j ]
			A <- train_norm[ w[1] ,]
			B <- train_norm[ w[2] ,]
			AB <- trnRANK[ w[1] ] < trnRANK[ w[2] ]
			# =================================================
			if (principle=="A"){
				r1 <- f_aggregation(func_Arithmetic(A,B,C,D), aggregator)
				r2 <- f_aggregation(func_Arithmetic(A,B,D,C), aggregator)
			}
			# =================================================
			if (principle=="Aprim"){
				r1 <- f_aggregation(func_Arithmetic(A,B,C,D, type=1), aggregator)
				r2 <- f_aggregation(func_Arithmetic(A,B,D,C, type=1), aggregator)
			}
			# =================================================
			if (principle=="G"){
				r1 <- f_aggregation( func_Geometric(A,B,C,D, bin_vec = bin), aggregator )
				r2 <- f_aggregation( func_Geometric(A,B,D,C, bin_vec = bin), aggregator )
			}
			# =================================================
			if (principle=="MM"){
				r1 <- f_aggregation( func_MinMax(A,B,C,D), aggregator )
				r2 <- f_aggregation( func_MinMax(A,B,D,C), aggregator )
			}
			# =================================================
			if (principle=="AE0.05"){
				r1 <- f_aggregation( func_Approximate(A,B,C,D, tolerance=0.05), aggregator )
				r2 <- f_aggregation( func_Approximate(A,B,D,C, tolerance=0.05), aggregator )
			}
			# =================================================
			if (principle=="AE0.1"){
				r1 <- f_aggregation( func_Approximate(A,B,C,D, tolerance=0.1), aggregator )
				r2 <- f_aggregation( func_Approximate(A,B,D,C, tolerance=0.1), aggregator )
			}
			# =================================================
			if (principle=="AEprim"){
				r1 <- f_aggregation( func_ApproximateGraded(A,B,C,D, bin_vec = bin), aggregator )
				r2 <- f_aggregation( func_ApproximateGraded(A,B,D,C, bin_vec = bin), aggregator )
			}
			
			analogy_scores[j] <- ifelse(r1>r2, r1, r2)
			prefs[j] <- !xor(AB, r1>r2)
		}
		
		top_k_inds <- order(-analogy_scores)[1:top_k]
		mat_prefs[i,] <- prefs[ top_k_inds ]
		mat_analogy_scores[i,] <- analogy_scores[ top_k_inds ]
	}
	
	list(
		principle=principle,
		pref=mat_prefs, 
		score=mat_analogy_scores
		)
}

#================== func_btmm ==================

# func_btmm computes the parameters using maximum likelihood principle

# This function is adapted from the Matlab version provided by David Hunter
# http://personal.psu.edu/drh20/code/btmatlab

# input:
 	# Data: n*n preference matrix
	# max_iter: maximum number of iterations if not converged earlier

# output: having the estimated parameter vector "info", the corresponding order will be returned

func_btmm <- function( Data, max_iter=1e4 ){

	func_L2_norm  <- function(x) sqrt(sum((x)^2)) # L2_norm (Euclidean norm)

	wm <- Data
	
	n <- nrow(wm)
	nmo <- n-1
	pi <- rep(1,nmo) # initial value:  All teams equal
	iteration <- 0
	change <- Inf
	gm <- t(wm[,1:nmo])+wm[1:nmo,]
	wins <- rowSums(wm[1:nmo,])
	gind <- gm>0
	z <- matrix(0, nmo, n)
	pisum <- z

	while (TRUE){
		iteration <- iteration+1
		pius <- matrix(rep(pi,n), byrow = F, nrow = nmo) # pi[,rep(1,n)]
		piust <- t(pius[,1:nmo])
		piust <- cbind(piust, rep(1,nmo))
		pisum[gind] <- pius[gind]+piust[gind]
		
		z[gind] <- gm[gind] / pisum[gind]
		newpi <- wins / rowSums(z)
		change <- newpi-pi
		pi <- newpi
		
		if ( func_L2_norm(change)<=1e-8 )
			break
			
		if (  iteration>=max_iter )
			break
	}
	info <- pi
	info[n] <- 1
	info <- info/sum(info)
	
	order(-info) # corresponding order
}

#================== func_RA ==================

# func_RA implements the Rank Aggregation (RA) algorithm proposed in [1]

# input:
	# prefs: the preference matrix 
	# K: the integer parametere K
	# n: to initialize an n*n matrix. "n" is essentially the no. of instances in the test data

# output: The predicted order

func_RA <- function( prefs, K, n ){

	C <- diag( n )-1
	
	s <- rowSums(prefs[,1:K,drop=FALSE])
	C[lower.tri(C, diag=FALSE)] <- s
	C <- t(C)
	C[lower.tri(C)] <- K-s
		
	pred_order <- func_btmm(C)
	pred_order
}
