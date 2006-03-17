{stdenv, bash, nettools, dhcp, key ? null, initscripts}:

stdenv.mkDerivation {
  name = "network-script-0.0.1";
  server = "network";
  nicename = "networking";
  builder = ./builder.sh ;
  inherit bash nettools dhcp initscripts;
  script = [./network];
}
