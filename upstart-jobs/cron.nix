{cron}:

{
  name = "cron";
  
  job = "
description \"Cron daemon\"

start on startup
stop on shutdown

respawn ${cron}/sbin/cron -n
  ";
  
}
