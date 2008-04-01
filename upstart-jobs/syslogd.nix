{sysklogd, writeText}:

let

  syslogConf = writeText "syslog.conf" ''
    *.*                /dev/tty10

    *.=warning;*.=err -/var/log/warn
    *.crit             /var/log/warn


    *.*               -/var/log/messages
  '';

in

{
  name = "syslogd";
  job = "
    start on udev
    stop on shutdown
    respawn ${sysklogd}/sbin/syslogd -n -f ${syslogConf}
  ";
}
