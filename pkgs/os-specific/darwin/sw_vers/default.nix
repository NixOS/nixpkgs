{stdenv}:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "darwin-sw-vers-utility";
  builder = ./builder.sh;
}
