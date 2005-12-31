{stdenv, fetchurl, gccCross, kernelHeadersCross, binutilsCross, cross}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "uClibc-0.9.28";
  src = fetchurl {
    url = http://www.uclibc.org/downloads/uClibc-0.9.28.tar.bz2;
    md5 = "1ada58d919a82561061e4741fb6abd29";
  };
  config = if cross == "mips-linux"
             then ./config-mips-linux
           else if cross == "arm-linux"
                  then ./config-arm-linux
                else "";

  inherit kernelHeadersCross;
  buildInputs = [gccCross binutilsCross];
  inherit cross;
}
