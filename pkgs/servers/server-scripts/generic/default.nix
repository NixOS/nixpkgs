{stdenv}:

stdenv.mkDerivation {
  name = "generic-server-script-0.0.1";
  server = "generic";
  nicename = "functions";
  builder = ./builder.sh ;
  functions = [./functions];
}
