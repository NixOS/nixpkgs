{stdenv}:
 
stdenv.mkDerivation {
  name = "gzip-static-1.3.3";
  builder = ./builder.sh;
  src = ./bin;
}
