# able2rank

### Real Data

**Facebook Metrics (FB):** The data is related to posts published during the year of 2014 on the Facebook page of a renowned cosmetics brand [1,2]. Each post is described in terms of 18 numeric, binary, and nominal features (e.g., type, category, month, weekday, hour, like, comment, share, total interactions). We removed those entries with missing values, and used the data from the first (FB1, 77 posts) and second quarter (FB2, 113 posts) of the year for training and testing. Rankings were defined based on the total interaction of each post (ignoring ties).

**FIFA WC (G):** This data [3] comprises rankings of the 32 teams that participated in the men's FIFA world cup 2014 and 2018, as well as under-17 in the year 2017 (22 instances) with respect to *goals statistics* (7 numeric features such as matches played, goals for, goals scored, etc.).

**NBA Teams and Players (N, P):** Ranking of the 30 NBA teams as well as top 50 players in the NBA for the seasons 2016/17 and 2017/18, obtained from NBA stats [4]. Each team is represented by 28 numeric features, such as games played, wins, losses, win percentage, etc. Players are described by 20 numeric features, such as games played, minutes played, points, field goals made, etc.

**Poker (PK):** Given the initial pair of cards as starting hand in an n-player Texas Holdem game, without seeing any of flop/turn/river cards, what is the probability that the starting hand will beat all other n-1 hands after the river? Based on this probability, [5] provides a ranking of all possible starting hands (hence 169 instances) in an n-player game on the basis of 4*10^9 simulated games. We represent each pair of cards by a 13-dimensional feature vector (corresponding to A, K, Q, J, T, 9, ..., 2) with values in {0,1,2. A value 0 or 1 indicates if the corresponding feature (card) is among the starting hand, and 2 indicates a pair of cards. In addition, a binary feature is used to indicate if the starting cards are of the same suit or not.

## Synthetic Data

**Answer Sheets (AS):** A set of answer sheets for multiple choice questions is ranked according to the score (3C-W)/(3Q), where Q, C, and W denote the number of questions, correct answers, and wrong answers, respectively. For fixed Q, instances are generated at random by sampling C uniformly from {1, ..., Q-1} and W uniformly from {0, Q-C}. Moreover, noisy (irrelevant) features of different type are added: 2 binary features in {0,1}, 2 nominal in {1,2,3,4,5}, and 3 integer features in {1,...,Q}. This process gives rise to data sets AS1 (Q=50) and AS2 (Q=100). Further, we doubled the number of noisy features (of each type) to produce data sets AS3 (Q=50) and AS4 (Q=100).

[1] Dua, D., Graff, C.: UCI machine learning repository, University of California, Irvine, School of Information and Computer Sciences,       http://archive.ics.uci.edu/ml (2017)

[2] Moro, S., Rita, P., Vala, B.: Predicting social media performance metrics and evaluation of the impact on brand building: A data mining     approach. Journal of Business Research 69(9), 3341{3351 (2016)

[3] www.fifa.com

[4] stats.nba.com

[5] Kapadia, A.: Pre-Flop Hole Card Winning Probabilities, https://www.cs.indiana.edu/kapadia/nofoldem/index.html (2005)
