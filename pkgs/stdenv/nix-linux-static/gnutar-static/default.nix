{stdenv}:
 
stdenv.mkDerivation {
  name = "gnutar-static-1.13.25";
  builder = ./builder.sh;
  src = ./tar-1.13.25-static.tar.gz;
}
