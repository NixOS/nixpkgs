{stdenv, fetchurl, perl}:

# Note: I added the Perl dependency for Valgrind 2.1.1.  It's needed
# to generate some files.  Maybe in stable releases we won't need
# Perl.
# Update: 2.4.0 still needs it.

stdenv.mkDerivation {
  name = "valgrind-2.4.0";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-2.4.0.tar.bz2;
    md5 = "1d0bd81d368789946d32d18a468ea0cf";
  };
  buildInputs = [perl];
}
