{sysklogd}:

{
  name = "syslogd";
  job = "
    start on startup
    stop on shutdown
    respawn ${sysklogd}/sbin/syslogd -n
  ";
}
