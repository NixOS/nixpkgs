{stdenv}:
 
stdenv.mkDerivation {
  name = "gzip-static-1.3.3";
  builder = ./builder.sh;
  src1 = ./gzip;
  src2 = ./gunzip;
}
