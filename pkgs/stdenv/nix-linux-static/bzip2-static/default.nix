{stdenv}:
 
stdenv.mkDerivation {
  name = "bzip2-static-1.0.2";
  builder = ./builder.sh;
  src = ./bzip2-1.0.2-static.tar.gz;
}
