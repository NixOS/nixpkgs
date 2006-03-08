{stdenv, bash, nettools, dhcp, key ? null}:

stdenv.mkDerivation {
  name = "network-script-0.0.1";
  server = "network";
  nicename = "networking";
  builder = ./builder.sh ;
  inherit bash nettools dhcp;
  script = [./network];
}
