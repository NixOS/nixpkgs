{sysklogd, writeText, config}:

let

  syslogConf = writeText "syslog.conf" ''
    *.*                           /dev/tty10

    # "local1" is used for dhcpd messages.
    local1.*                     -/var/log/dhcpd

    mail.*                       -/var/log/mail

    *.=warning;*.=err            -/var/log/warn
    *.crit                        /var/log/warn

    *.*;mail.none;local1.none    -/var/log/messages
  '';

in

{
  name = "syslogd";
  job = ''
    start on udev
    stop on shutdown

    env TZ=${config.time.timeZone}
    
    respawn ${sysklogd}/sbin/syslogd -n -f ${syslogConf}
  '';
}
