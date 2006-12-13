{sysklogd}:

{
  name = "syslogd";
  job = "
    start on udev
    stop on shutdown
    respawn ${sysklogd}/sbin/syslogd -n
  ";
}
