{stdenv, fetchurl, jdk, python}:

stdenv.mkDerivation {
  name = "antlr-2.7.7";
  src = fetchurl {
    url = "http://www.antlr2.org/download/antlr-2.7.7.tar.gz";
    sha256 = "1ffvcwdw73id0dk6pj2mlxjvbg0662qacx4ylayqcxgg381fnfl5";
  };
  patches = [ ./2.7.7-fixes.patch ];
  buildInputs = [jdk python];
}
