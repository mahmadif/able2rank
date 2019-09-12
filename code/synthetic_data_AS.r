
# References:
	# [1] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Feature Selection for Analogy-Based Learning to Rank, Proceedings of the 22nd International Conference on Discovery Science (DS 2019)

#================== f_synthetic_data_answer_sheet ==================

# f_synthetic_data_answer_sheet implements the synthetic data set named Answer Sheets in Sec. 4 in [1]

# input:
	# nr: no. of instances to be generated
	# N_question: the fixed no. of questions (i.e., 50) in answer sheets
	# N_binary: no. of (irrelevant) binary attributes \in {0,1} to be added
	# N_nominal: no. of (irrelevant) nominal attributes \in {1,2,3,4,5} to be added
	# N_integer: no. of (irrelevant) integer attributes \in {1,...,N_question} to be added
# output:
	# returns the generated data set in the form of a data frame named "df"

f_synthetic_data_answer_sheet <- function( nr, N_question = 50, N_binary, N_nominal, N_integer ){
    
    # sampling C uniformly from {1, ..., Q-1}
    m1 <- replicate(1, sample(1:(N_question-1), nr, replace = TRUE))
    
    # sampling W uniformly from {0, Q-C}
    m1 <- cbind( m1, apply(N_question-m1, 1, function(x) ifelse( x>1, sample(0:x, 1), 0 ) ) )
    
    m1 <- cbind(
        "correct" = m1[,1],
        "wrong" = m1[,2],
        matrix(sample(1:N_question, nr*N_integer, replace = TRUE), ncol = N_integer),
        matrix(sample(0:1, nr*N_binary, replace = TRUE), ncol = N_binary),
        "unanswered" = N_question-(m1[,1]+m1[,2]),
	matrix(sample(1:5, nr*N_nominal, replace = TRUE), ncol = N_nominal)
        )
    
    # score <- (3C-W)/(3Q)
    score <- ((m1[,1]*3)-m1[,2]) / (N_question*3) 
    
	list(
		df = data.frame( cbind( m1[ order(-score), ], "RANK" = 1:nr ) ),
		inf = paste0( "answerSheet_nc", ncol(m1), "_nr", nr )
		)
}
