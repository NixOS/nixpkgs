{stdenv, fetchurl, perl}:

# Note: I added the Perl dependency for Valgrind 2.1.1.  It's needed
# to generate some files.  Maybe in stable releases we won't need
# Perl.

stdenv.mkDerivation {
  name = "valgrind-2.1.1";
  src = fetchurl {
    url = http://developer.kde.org/~sewardj/valgrind-2.1.1.tar.bz2;
    md5 = "0010c3e8f054ecc633151c62044b646d";
  };
  buildInputs = [perl];
}
