# Valgrind has to be in the same prefix and I didn't feel like
# patching. So, valgrind is installed here as well.

{stdenv, fetchurl, which, perl}:

stdenv.mkDerivation {
  name = "callgrind-0.10.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://kcachegrind.sourceforge.net/callgrind-0.10.0.tar.gz;
    md5 = "3bd2afd50fde7db4bd5a59dcb412d5e7";
  };

  valgrindsrc = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.0.1.tar.bz2;
    md5 = "c29efdb7d1a93440f5644a6769054681";
  };

  buildInputs = [which perl];
}
