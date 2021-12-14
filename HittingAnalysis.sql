-- Select top 1000
select top 1000
	*
from
	Stats


-- Find number of different players
select
	count(distinct ID) as num_players
from
	Stats


-- Find all different teams
select
	distinct Tm
from
	Stats
order by
    Tm


-- Group player stats by season
select
	ID,
	Player as player_name,
	season,
	sum(AB) as season_AB,
	sum(H) as season_hits,
	(cast(sum(H) as float) / nullif(cast(sum(AB) as float),0)) as batting_average
from
	Stats
group by
	ID, season, Player
order by
	season, ID


-- Group team stats by season
select
	Tm,
	season,
	sum(AB) as season_ab,
	sum(H) as season_hits,
	(cast(sum(H) as float) / nullif(cast(sum(AB) as float), 0)) as batting_avg
from
	Stats
group by
	season, Tm
order by
	season, batting_avg desc, Tm


-- Find top hitter by batting average for each season
with
	cte1 as
	(
		select
			ID,
			Player,
			p.season,
			(cast(sum(H) as float) / nullif(cast(sum(AB) as float), 0)) as batting_avg,
			cast(sum(PA) as float) / cast(games_played as float) as pa_gm
		from
			Stats p
		join
		(
			select
				Tm,
				season,
				count(distinct game_id) as games_played
			from
				Stats
			group by
				Tm, season
		) t on t.Tm = p.Tm and t.season = p.season
		group by
		ID, p.season, Player, games_played
	),
	cte2 as
	(
		select
			*,
			row_number() over (partition by season order by batting_avg desc) as rn
		from
			cte1
		where
		pa_gm >= 3.1
	)
select
	ID,
	Player,
	season,
	batting_avg
from
	cte2
where
	rn = 1


-- Find top hitter by home runs for each season
with
	cte1 as
	(
		select
			ID,
			Player,
			season,
			sum(AB) as season_ab,
			sum(HR) as season_hr
		from
			Stats
		group by
		ID, season, Player
	),
	cte2 as
	(
		select
			*,
			row_number() over (partition by season order by season_hr desc) as rn
		from
			cte1
	)
select
	ID,
	Player,
	season,
	season_ab,
	season_hr
from
	cte2
where
	rn = 1


-- Find top hitter by runs created for each season
with
	cte1 as
	(
		select
			ID,
			Player,
			season,
			sum(AB) as season_ab,
			sum(H) as season_hits,
			sum(HR) as season_hr,
			(cast(((sum(H) + sum(BB))*(4*sum(HR) + 3*sum([3B]) + 2*sum([2B]) + (sum(H) - sum(HR) - sum([3B]) - sum([2B])))) as float)/nullif(cast((sum(AB) + sum(BB)) as float), 0)) as rc
		from
			Stats
		group by
			ID, season, Player
	),
	cte2 as
	(
		select
			*,
			row_number() over (partition by season order by rc desc) as rn
		from
			cte1
	)
select
	ID,
	Player,
	season,
	season_ab,
	season_hits,
	season_hr,
	rc
from
	cte2
where
	rn = 1


-- Find average BA for each season
select
	season,
	(cast(sum(H) as float) / nullif(cast(sum(AB) as float), 0)) as batting_avg
from
	Stats
where
	AB > 0
group by
	season
order by
	season


-- Find total and average HR for each season
select
	season,
	sum(HR) as total_hr,
	cast(sum(HR) as float) / cast(sum(AB) as float) as hr_avg
from
	Stats
group by
	season
order by
	season


-- Find average runs created for each season
select
	season,
	sum(H) as H,
	sum(AB) as AB,
	sum(BB) as BB,
	sum([2B]) as '2B',
	sum([3B]) as '3B',
	sum(HR) as HR,
	(
		select
			count(distinct ID)
		from
			Stats a
		where
			a.season = b.season
	) as player_count
from
	Stats b
group by
	season
order by
	season


-- Find average and total strikeouts for each season
select
	season,
	cast(sum(SO) as float)/cast(sum(AB) as float) as k_avg,
	sum(SO) as k_total
from
	Stats
group by
	season
order by
	season


-- Find average runs per game for each season
select
	season,
	count(distinct game_id) as games_played,
	sum(R) as runs_scored
from
	Stats
group by
	season
order by
	season


-- Find top hitter by on-base percentage for each season
with
	cte1 as
	(
		select
			ID,
			Player,
			p.season,
			(cast((sum(H) + sum(BB) + sum(HBP)) as float)  / nullif(cast((sum(AB) + sum(BB) + sum(HBP) + sum(SF)) as float), 0)) as obp,
			cast(sum(PA) as float) / cast(games_played as float) as pa_gm
		from
			Stats p
		join
		(
			select
				Tm,
				season,
				count(distinct game_id) as games_played
			from
				Stats
			group by
				Tm,
				season
		) t on t.Tm = p.Tm and t.season = p.season
		group by
		ID, p.season, Player, games_played
	),
	cte2 as
	(
		select
			*,
			row_number() over (partition by season order by obp desc) as rn
		from
			cte1
		where
			pa_gm >= 3.1
	)
select
	ID,
	Player,
	season,
	obp
from
	cte2
where
	rn = 1


-- Find average OBP for each season
select
	season,
	(cast((sum(H) + sum(BB) + sum(HBP)) as float)  / nullif(cast((sum(AB) + sum(BB) + sum(HBP) + sum(SF)) as float), 0)) as obp
from
	Stats
where
	PA > 0
group by
	season
order by
	season