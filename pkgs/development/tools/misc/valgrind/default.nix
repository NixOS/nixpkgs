{stdenv, fetchurl, perl}:

# Note: I added the Perl dependency for Valgrind 2.1.1.  It's needed
# to generate some files.  Maybe in stable releases we won't need
# Perl.
# Update: 2.2.0 still needs it.

stdenv.mkDerivation {
  name = "valgrind-2.2.0";
  src = fetchurl {
    url = http://developer.kde.org/~sewardj/valgrind-2.2.0.tar.bz2;
    md5 = "30dc51f6fc94751b90b04af9c2e2c656";
  };
  buildInputs = [perl];
}
