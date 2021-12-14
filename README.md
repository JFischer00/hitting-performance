# MLB Hitting Performance Project

## Project Introduction
The main goal of this project is to determine whether MLB hitters are getting better over time. There has been a lot of study recently on new techniques that involve launch angles, bat speed, and exit velocity. The goal of this approach is to increase hard hit line drives and fly balls. Naturally this should lead to batters hitting more home runs, but is it making them overall better hitters? That's what we'll look at as we go through this project.

## Data Preparation
### Obtaining & Understanding
The data used for this project was sourced from Kaggle [here](https://www.kaggle.com/darinhawley/mlb-batting-stats-by-game-19012021). It has been released to the public domain for free usage. The dataset contains information about hitting performance for every player in every game during every season from 1901-2021. It contains about 4.3M rows of data. Each row contains a player's stats from one game.

Each row has 31 fields, many of which I didn't use. Here's a quick description of the fields I did use:
- **ID** - Unique ID for the player
- **Player** - Name of the player
- **Date** - Date the game was played (with a number appended for each game of a double or triple header)
- **Tm** - Player's team
- **PA** - Number of plate appearances
- **AB** - Number of at-bats
- **R** - Number of runs scored
- **H** - Number of hits
- **2B** - Number of doubles
- **3B** - Number of triples
- **HR** - Number of home runs
- **BB** - Number of walks
- **SO** - Number of strikeouts
- **HBP** - Number of hit-by-pitches
- **SF** - Number of sacrifice flies
### Cleaning & Transforming
For my cleaning process, I began by importing the CSV dataset into RStudio. [There](HittingCleaning.R) I quickly split the date column, so the game number would be in its own separate column.

Then I imported the resulting CSV into SQL Server using SSMS. The first thing I did in SQL was check for duplicates. Somewhere in the process I did acquire quite a few duplicates, so I went to remove them. Unfortunately, with such a large dataset, it was a little more difficult than I had imagined, but eventually I was able to make it work using [this](HittingDuplicates.sql) set of queries.

Next, I added a couple helper columns:
- **season** - Just the year part of the date column
- **game_id** - A composite key for identifying unique games, made from **Tm**, **Opp**, **date**, and **game_num**

Finally, I checked for any instances of 0 PA or AB to ensure no completely null rows. My cleaning queries can be found [here](HittingCleaning.sql)
## Data Analysis
First, I ran some descriptive queries, just to get a feel for the dataset (all of my queries can be found [here](HittingAnalysis.sql)). Next, I began identifying possible baseball statistics I could use to try to predict overall hitting performance. I ended up deciding to use batting average, home runs, strikeouts, runs per game, and on-base percentage in my [final presentation](https://youtu.be/hrNl77nb5k8). For some of these statistics, I compared league averages vs league leaders, which led to interesting insights.

I wasn't able to make a definite conclusion about my initial hypothesis, as there are many factors and much more complex research that can be and has been done on this subject. I was able to draw a couple interesting conclusions though, and all of my Tableau visualizations are available [here](HittingViz.twbx).
## Project Conclusion
After working through this project I came to a few conclusions:

1. The new approach to hitting works...to increase overall home runs. Home runs across the league have grown exponentially over time. League leaders, however, have not been affected by this same trend.
2. More home runs doesn't equal more runs scored. Even as home run counts shot up across the league, runs per game remained steady, even slightly declining over time.
3. Home runs are not a good measure of overall hitting performance. As home runs grew exponentially, strikeouts did too. Meanwhile, batting average and on-base percentage stayed level or even dipped slightly. Clearly there's more to being a great hitter than just home runs.

None of these definitively answer my original hypothesis, but they are all valuable insights nonetheless, and this was a fun project for me to work on.
