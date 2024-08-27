# NFL Tendency & analytics visualiser

## How to update data

### pbp_db database
This database used the R package [NFL Fast R](https://www.nflfastr.com/articles/nflfastR.html) to collect play-by-play data  

Use the script ```LoadDB.R``` to update the SQLlite database. (Not part of repo)


### nfl_2024_schedule.db  
To load the 2024 schedule use the ``nfl_schedule_to_sql.py`` script and enrich with ``addtoDivisions.py`` to update the database with info about indivion games or not.  

Use the ``getSpreads.py` script to update the latest spread using [https://api.the-odds-api.com](https://api.the-odds-api.com) - Provide your own key.



## Web app  
Is a read only app, that gets an overview of upcomming games.