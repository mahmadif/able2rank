# References:
	# [1] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Feature Selection for Analogy-Based Learning to Rank, Proceedings of the 22nd International Conference on Discovery Science (DS 2019)

f_sign_agreement <- function( AminusB, CminusD ) AminusB*CminusD>0

#================== f_correlation ==================

# f_correlation implements the proposed correlation-based feature selection algorithm as described in Sec. 3.1 in [1]

# input:
	# trn_normed: train data \in [0,1]^d where d is dimension
	# Y_train: ranking of the instances in the training data

# output: The weight vector representing the merit of each feature

f_correlation <- function( trn_normed, Y_train ){

	trn_normed_sorted <- trn_normed[ order(Y_train),,drop=FALSE ]
	cmb <- combn(nrow(trn_normed), 4)

	sc1 <- trn_normed_sorted[ cmb[1,],,drop=FALSE ] - trn_normed_sorted[ cmb[2,],,drop=FALSE ]
	sc2 <- trn_normed_sorted[ cmb[3,],,drop=FALSE ] - trn_normed_sorted[ cmb[4,],,drop=FALSE ]
	
	(
		colSums( f_sign_agreement(sc1,sc2) ) - colSums( f_sign_agreement(sc1,-sc2) )
	) / nrow(sc1)
}

#================== f_IRELIEF ==================

# f_IRELIEF implements the proposed I-Relief-based feature selection algorithm as described in Sec. 3.3 in [1]

# input:
	# x: train data \in [0,1]^d where d is dimension
	# rnk: ranking of the instances in the training data
	# sigma: kernel width
	# theta: stopping parameter

# output: The weight vector representing the merit of each feature

f_IRELIEF <- function( x, rnk, sigma, theta ){

	f_IRELIEF_compute_w <- function( AB, prefsAB, sigma, W ){

		f <- function( d ) exp( -d/sigma )
		
		f_row_wise_prod <- function( mat, vec ) t( t(mat)*vec )
		f_col_wise_prod <- function( mat, vec ) t(  vec*t( mat ) )
		
		f_norm_w <- function( Xn, Xi, weighted = TRUE ){
		
			M1 <- 1 - abs( Xn - Xi )
			M1[ !f_sign_agreement(Xn,Xi) ] <- 0
			
			if ( weighted==FALSE )
				return( M1 )
			
			rowMeans( f_row_wise_prod( M1, W ) )
		}
		
		P_m <- function(){

			norm_w <- f_norm_w( Xn, Mn )
			f( norm_w ) / sum( f( norm_w ) )
		}

		P_h <- function(){
		
			norm_w <- f_norm_w( Xn, Hn )
			f( norm_w ) / sum( f( norm_w ) )
		}
		
		P_o <- function(){

			num <- sum( f( f_norm_w( Xn, Mn ) ) )
			
			D <- rbind( Hn, Mn )
			denom <- sum( f( f_norm_w( rbind( Xn, Xn ), D ) ) )
			
			num / denom
		}
		
		v <- numeric( ncol(AB) )
		N <- nrow(AB)

		for ( i in 1:N ){
			
			x_n <- AB[ i, ]
			m <- AB[ -i, ]
			
			vec_lbl <- prefsAB[ i ]
			lbls <- prefsAB[ -i ]
			prefs <- lbls==vec_lbl
			
			sgns <- prefs*2-1
			
			Hn <- sgns * m
			Mn <- (-sgns) * m
			
			Xn <- matrix( x_n, nrow = nrow(m), ncol = ncol(m), byrow = TRUE )
			
			alpha_in <- P_m()
			beta_in <- P_h()
			
			gamma_n <- 1 - P_o()
			
			m_in <- f_norm_w( Xn, Mn, weighted = FALSE )
			h_in <- f_norm_w( Xn, Hn, weighted = FALSE )
			
			m_n <- colSums( f_col_wise_prod( m_in, alpha_in ) )
			h_n <- colSums( f_col_wise_prod( h_in, beta_in ) )
			
			v <- v + ( gamma_n * ( h_n - m_n ) )
		}
		
		v <- v / N
		
		v_p <- pmax( rep( 0, length(v) ), v )
		v_p / norm( v_p, type = "2" )
	}

	cmb <- combn( nrow(x), 2 )
	
	AB <- x[ cmb[1,],,drop=FALSE ] - x[ cmb[2,],,drop=FALSE ]
	prefsAB <- rnk[ cmb[1,] ] < rnk[ cmb[2,] ]

	W_old <- rep( 1/ncol(x), ncol(x) )
	
	mat_W <- matrix( W_old, 1, ncol(x) )
	colnames( mat_W ) <- colnames(x)
	iter <- 0
	cat( sprintf( "sigma = %f\n", sigma ) )
	while ( TRUE ){
	
		iter <- iter+1
		cat( iter, "|" )
		
		W <- f_IRELIEF_compute_w( AB, prefsAB, sigma, W_old )
		
		mat_W <- rbind( mat_W, W )
		
		if ( norm( W - W_old, type = "2" ) < theta )
			break
		
		W_old <- W
	}

	
	list( 
		mat_W = mat_W,
		W = mat_W[ nrow(mat_W), ],
		N_iter = iter 
		)
}

#================== f_RELIEF_F ==================

# f_RELIEF_F implements the proposed Relief-F-based feature selection algorithm as described in Sec. 3.3 in [1]

# input:
	# x: train data \in [0,1]^d where d is dimension
	# rnk: ranking of the instances in the training data
	# Knn: the no. of nearest neighbors

# output: The weight vector representing the merit of each feature

f_RELIEF_F <- function( x, rnk, Knn ){

	f_find_nn <- function( m, vec, prefs ){

		m_vec <- matrix( vec, nrow = nrow(m), ncol = ncol(m), byrow = TRUE )
		
		sgns <- prefs*2-1 
		
		m_hits <- sgns * m
		m_misses <- (-sgns) * m
		
		s_hits <- 1 - abs( m_hits - m_vec )
		s_hits[ !f_sign_agreement(m_vec, m_hits) ] <- 0
		
		s_misses <- 1 - abs( m_misses - m_vec )
		s_misses[ !f_sign_agreement(m_vec, m_misses) ] <- 0
		
		ind_hits_topK <- order( -rowMeans(s_hits) )[ 1:Knn ]
		ind_misses_topK <- order( -rowMeans(s_misses) )[ 1:Knn ]
		
		list(
			s_near_hit = s_hits[ ind_hits_topK,,drop=F ],
			s_near_miss = s_misses[ ind_misses_topK,,drop=F ]
			)
	}
	
	cmb_train <- combn( nrow(x), 2 )
	
	AB <- x[ cmb_train[1,],,drop=FALSE ] - x[ cmb_train[2,],,drop=FALSE ]
	prefsAB <- rnk[ cmb_train[1,] ] < rnk[ cmb_train[2,] ]

	W <- numeric( ncol(x) )

	for ( i in 1:nrow(AB) ){
		
		vec <- AB[ i, ]
		m <- AB[ -i, ]
		
		vec_lbl <- prefsAB[ i ]
		lbls <- prefsAB[ -i ]
		
		prefs <- lbls==vec_lbl
		
		res_nn <- f_find_nn( m, vec, prefs )
		
		s_near_hit <- res_nn$s_near_hit
		s_near_miss <- res_nn$s_near_miss
		
		W <- W + colMeans( s_near_hit ) - colMeans( s_near_miss )
	}

	list(
		N = nrow(AB),
		WW = W,
		W = W[ W>0 ]
	)
}
