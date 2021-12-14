drop table #temp

select
	*,
	row_number() over (partition by ID, Player, date_new, game_num order by ID) as rn
into
	#temp
from
	Stats

declare @r int
set @r = 1

while @r > 0
begin
	begin transaction
	delete top (100000)
	from
		#temp
	where
		rn > 1
	
	set @r = @@rowcount

	commit transaction

	checkpoint
end

drop table Stats

select
	*
into Stats
from #temp

alter table Stats
drop column rn