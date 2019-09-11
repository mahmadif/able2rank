# able2rank

able2rank (**a**nalogy-**b**ased **le**arning **to rank**) is a learning to rank algorithm proposed in [+] for the task of object ranking on the basis of analogical reasoning.

The following collection of data sets is used for the task of learning to rank (specifically, object ranking) in the following papers:

* [+] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Learning to Rank Based on Analogical Reasoning, 
Proceedings of the Thirty-Second AAAI Conference on Artificial Intelligence (AAAI 2018) 

* [++] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Analogy-Based Preference Learning with Kernels, 
Proceedings of Advances in Artificial Intelligence (KI 2019)

* [+++] Mohsen Ahmadi Fahandar, Eyke Hüllermeier, Feature Selection for Analogy-Based Learning to Rank, 
Proceedings of the 22nd International Conference on Discovery Science (DS 2019) 

### Real Data
---
**Bundesliga (B):** This data set comprises table standings of
18 football teams in the German Bundesliga (German
football league) for the seasons 2015/16 (`ds_B1`) and 2016/17 (`ds_B2`) [1].
Each team is described in terms of 13 features, such as
matches, win, loss, draw, goals-for, goals-against, etc. 

**Decathlon (D):** This data contains rankings of the top 100
men’s decathletes worldwide in the years 2005 (`ds_D1`) and 2006 (`ds_D2`),
with 10 numeric features associated with each athlete.
Each feature is the performance achieved by the athlete in
the corresponding discipline (e.g., the time in 100 meter
race). The ranking of the decathletes is based on a scoring scheme, in which each performance is first scored in
terms of a certain number of points (the mapping from
performance to scores is non-linear), and the total score is
obtained as the sum of the points over all 10 disciplines.
In addition, the results of Olympic games Rio de Janeiro
2016 (`ds_D3`, 24 instances) as well as under-20 world championships 2016 (`ds_D4`, 22 instances) are considered. The data are
extracted from the Decathlon2000 web site [2].

**FIFA (F):** The FIFA Index website [3] ranks the best football
players in the world based on different metrics each year.
These metrics belong to different categories, such as ball
skills (ball control, dribbling, etc.), physical performance
(acceleration, balance, etc.), defence (marking, slide tackling, etc.), and so on. We considered the list of top 100
footballers in the years 2016 (`ds_F1`) and 2017 (`ds_F2`), where each player
is described by 40 attributes. Since the metrics of different types of players are not comparable, the overall evaluation of a player depends on his position (goal keeper,
defender, streaker, etc.). Obviously, predicting the overall ranking is therefore a difficult task. In addition to the
full data sets, we therefore also considered two positionspecific data sets, namely the rankings for players with
position streaker in the years 2016 (`ds_F3`) and 2017 (`ds_F4`).

**Facebook Metrics (FB):** The data is related to posts published during the year of 2014 on the Facebook page of a renowned cosmetics brand [4,5]. Each post is described in terms of 18 numeric, binary, and nominal features (e.g., type, category, month, weekday, hour, like, comment, share, total interactions). We removed those entries with missing values, and used the data from the first (`ds_FB1`, 77 posts) and second quarter (`ds_FB2`, 113 posts) of the year for training and testing. Rankings were defined based on the total interaction of each post (ignoring ties).

**FIFA WC (G):** This data [6] comprises rankings of the 32 teams that participated in the men's FIFA world cup 2014 (`ds_G1`) and 2018 (`ds_G2`), as well as under-17 in the year 2017 (`ds_G3`, 22 instances) with respect to *goals statistics* (7 numeric features such as matches played, goals for, goals scored, etc.).

**Hotels (H):** This data set contains rankings of hotels in two
major German cities, namely Dusseldorf (`ds_H1`, 110 hotels) and ¨
Frankfurt (`ds_H2`, 149 hotels). These rankings have been collected from TripAdvisor [7] in September 2014. Each hotel
is described in terms of a feature vector of length 28 (e.g.,
distance to city center, number of stars, number of rooms,
number of user rating, etc). The way in which a ranking is
determined by TripAdvisor on the basis of these features
is not known (and one cannot exclude that additional features may play a role).

**Netflix (N):** This data set includes the Netflix ISP speed index (extracted from Netflix website [8] in August, 2017) for
Germany (`ds_N1`) and USA (`ds_N2`) with 9 and 13 Internet providers, respectively. The Netflix ISP Speed Index is a measure of
prime time Netflix performance on particular internet service providers (ISPs) around the globe. The rankings are
represented by 7 (binary and numeric) features like speed,
speed of previous month, fiber, cable, etc.

**NBA Teams and Players (T, P):** Ranking of the 30 NBA teams as well as top 50 players in the NBA for the seasons 2016/17 (`ds_T1` and `ds_P1`, resp.) and 2017/18 (`ds_T2` and `ds_P2`, resp.), obtained from NBA stats [9]. Each team is represented by 28 numeric features, such as games played, wins, losses, win percentage, etc. Players are described by 20 numeric features, such as games played, minutes played, points, field goals made, etc.

**Poker (PK):** Given the initial pair of cards as starting hand in an N-player Texas Holdem game, without seeing any of flop/turn/river cards, what is the probability that the starting hand will beat all other n-1 hands after the river? Based on this probability, [10] provides a ranking of all possible starting hands (hence 169 instances) in an N-player game on the basis of 4*10^9 simulated games. We represent each pair of cards by a 13-dimensional feature vector (corresponding to A, K, Q, J, T, 9, ..., 2) with values in {0,1,2}. A value 0 or 1 indicates if the corresponding feature (card) is among the starting hand, and 2 indicates a pair of cards. In addition, a binary feature is used to indicate if the starting cards are of the same suit or not. `ds_PK1`, `ds_PK2` and `ds_PK3` correspond to N=10, N=9 and N=5, respectively.

**University Rankings (U):** This data includes the list of top 100
universities worldwide for the years 2015 (`ds_U1`) and 2014 (`ds_U2`). It is
published by the Center for World University Rankings
(CWUR). Each university is represented by 9 features
such as national rank, quality of education, alumni employment, etc. Detailed information about how the ranking is determined based on these features can be found on the CWUR website [11].

**Volleyball WL (V):** This data contains the table standing for
Group1 (`ds_V2`, statistics of 12 teams divided into subgroups,
each with 9 matches) and Group3 (`ds_V1`, statistics of 12 teams,
each with 6 matches) of volleyball world league 2017 extracted from the FIVB website [12]. There are 12 features in
total, such as win, loss, number of (3-0, 3-1, 3-2, etc.)
wins, sets win, sets loss, etc.

### Synthetic Data
---
**Answer Sheets (AS):** A set of answer sheets for multiple choice questions is ranked according to the score (3C-W)/(3Q), where Q, C, and W denote the number of questions, correct answers, and wrong answers, respectively. For fixed Q=50, N instances are generated at random by sampling C uniformly from {1, ..., Q-1} and W uniformly from {0, Q-C}. Moreover, noisy (irrelevant) features of different type are added: 2 binary features in {0,1}, 2 nominal in {1,2,3,4,5}, and 3 integer features in {1,...,Q}. This process gives rise to data sets `ds_synthetic_AS1` (N=50) and `ds_synthetic_AS2` (N=100). Further, we doubled the number of noisy features (of each type) to produce data sets `ds_synthetic_AS3` (N=50) and `ds_synthetic_AS4` (N=100).

### References
---
[1] www.bundesliga.com

[2] www.decathlon2000.com

[3] www.fifaindex.com

[4] Dua, D., Graff, C.: UCI machine learning repository, University of California, Irvine, School of Information and Computer Sciences,       http://archive.ics.uci.edu/ml (2017)

[5] Moro, S., Rita, P., Vala, B.: Predicting social media performance metrics and evaluation of the impact on brand building: A data mining     approach. Journal of Business Research 69(9), 3341{3351 (2016)

[6] www.fifa.com

[7] www.tripadvisor.com

[8] ispspeedindex.netflix.com

[9] stats.nba.com

[10] Kapadia, A.: Pre-Flop Hole Card Winning Probabilities, https://cs.indiana.edu/~kapadia/nofoldem/ (2005)

[11] www.cwur.org

[12] worldleague.2017.fivb.com

### Citations
---
If you use the analogy-based learning to rank algorithm (`/code/able2rank.r`) in your research, please cite the following paper:

```
@inproceedings{ahmadif_huellermeier_aaai18,
  title={Learning to Rank Based on Analogical Reasoning},
  author={Mohsen {Ahmadi Fahandar} and Eyke H\"ullermeier},
  booktitle={Proceedings AAAI--2018, 32th AAAI Conference on Artificial Intelligence},
  address={New Orleans, Louisiana, USA},
  pages = {2951--2958},
  year=2018
}
```

If you use the source code for feature selection (`/code/fs.r`) or provided datasets (`/data`) in your research, please consider citing:

```
@inproceedings{ahmadif_huellermeier_ds19,
  title={Feature Selection for Analogy-Based Learning to Rank},
  author={Mohsen {Ahmadi Fahandar} and Eyke H\"ullermeier},
  booktitle={Proceedings DS--2019, 22nd International Conference on Discovery Science},
  address={Split, Croatia},
  year=2019
}
```
OR
```
@inproceedings{ahmadif_huellermeier_ki19,
  author={Mohsen {Ahmadi Fahandar} and Eyke H\"ullermeier},
  title = "{Analogy-Based Preference Learning with Kernels}",
  booktitle = {KI--2019: Advances in Artificial Intelligence},
  volume = "11793",
  pages="34--47",
  publisher="Springer International Publishing",
  address="Cham",
  year = "2019"
}
```
