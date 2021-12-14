-- Add season column from year of date_new column
alter table Stats
add season as datepart(year, date_new)


-- Find any instances of 0 PA in a game
select
	*
from
	Stats
where
	PA = 0


-- Find any instances of 0 AB in a game
select
	*
from
	Stats
where
	AB = 0


-- Add game_id column to easily identify individual games for each team
alter table Stats
add game_id as concat(Tm, Opp, date_new, game_num)