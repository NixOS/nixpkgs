{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "modutils-2.4.27";
  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/modutils/v2.4/modutils-2.4.27.tar.bz2;
    md5 = "bac989c74ed10f3bf86177fc5b4b89b6";
  };
  buildInputs = [bison flex];
}
