{stdenv}:
 
stdenv.mkDerivation {
  name = "curl-static-7.12.2";
  builder = ./builder.sh;
  src = ./curl-7.12.2-static.tar.gz;
}
