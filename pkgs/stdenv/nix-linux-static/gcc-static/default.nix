{stdenv}:
 
stdenv.mkDerivation {
  name = "gcc-static-3.3.4";
  builder = ./builder.sh;
  src = ./gcc-3.3.4-static.tar.gz;
  langC = true;
  langCC = false;
  langF77 = false;
}
