{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-20180226";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "0bec5d56c6938c2f28417bb5fd1c4b05ea2e7d28";
    sha256 = "0sifr3bkmhyr5s6ljgfyr0fw6w49ajf11rlp1r797f3r3r6j9w4k";
  };

  installPhase = "mkdir -p $out; mv * $out/";
  dontFixup = true;

  meta = {
    homepage = http://www.gnu.org/software/gnulib/;
    description = "Central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
