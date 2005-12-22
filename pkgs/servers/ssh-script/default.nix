{stdenv, ssh, bash, initscripts, coreutils, key ? null}:

stdenv.mkDerivation {
  name = "ssh-script-0.0.1";
  server = "ssh";
  builder = ./builder.sh ;
  inherit bash ssh initscripts coreutils;
  script = [./sshd];
}
