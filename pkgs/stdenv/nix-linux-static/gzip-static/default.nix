{stdenv}:
 
stdenv.mkDerivation {
  name = "gzip-static-1.3.3";
  builder = ./builder.sh;
  src = ./gzip-1.3.3-static.tar.gz;
}
