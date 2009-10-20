{stdenv}:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "darwin-arch-utility";
  builder = ./builder.sh;
}
