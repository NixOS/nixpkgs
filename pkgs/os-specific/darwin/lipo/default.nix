{stdenv}:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "darwin-lipo-utility";
  builder = ./builder.sh;
}
