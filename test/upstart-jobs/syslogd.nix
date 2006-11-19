{genericSubstituter, sysklogd}:

genericSubstituter {
  src = ./syslogd.sh;
  dir = "etc/event.d";
  name = "syslogd";
  inherit sysklogd;
}
