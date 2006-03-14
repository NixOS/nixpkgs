{stdenv, ssh, bash, initscripts, coreutils, key ? null, syslog ? null, networking}:

stdenv.mkDerivation {
  name = "ssh-script-0.0.1";
  nicename = "sshd";
  server = "ssh";
  builder = ./builder.sh ;
  softdeps = [syslog];
  deps = [networking];
  inherit bash ssh initscripts coreutils;
  script = [./sshd];
}
