{sysklogd, writeText, config}:

let

  syslogConf = writeText "syslog.conf" ''
    kern.warning;*.err;authpriv.none /dev/tty10

    # Send emergency messages to all users.
    *.emerg                       *

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
    description "Syslog daemon"
  
    start on udev
    stop on shutdown

    env TZ=${config.time.timeZone}
    
    respawn ${sysklogd}/sbin/syslogd -n -f ${syslogConf}
  '';
}
