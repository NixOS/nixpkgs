# Valgrind has to be in the same prefix and I didn't feel like
# patching. So, valgrind is installed here as well.

{stdenv, fetchurl, which, perl}:

stdenv.mkDerivation {
  name = "callgrind-0.10.1pre";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~mbravenb/clg3-cvs-2005.11.11.tar.gz;
    md5 = "c272cff1c567ba154ccc60fe2ff241d8";
  };

  valgrindsrc = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.0.1.tar.bz2;
    md5 = "c29efdb7d1a93440f5644a6769054681";
  };

  buildInputs = [which perl];
}
