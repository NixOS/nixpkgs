{stdenv, bash, syslog}:

stdenv.mkDerivation {
  name = "syslog-script-0.0.1";
  server = "syslog";
  nicename = "syslog";
  builder = ./builder.sh ;
  inherit bash syslog;
  script = [./syslog];
}
