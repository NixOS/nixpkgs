{stdenv}:
 
stdenv.mkDerivation {
  name = "curl-static-7.12.0";
  builder = ./builder.sh;
  src = ./curl-7.12.0-static.tar.gz;
}
