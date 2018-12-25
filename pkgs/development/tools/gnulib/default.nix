{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-20180226";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/r/gnulib.git";
    rev = "0bec5d56c6938c2f28417bb5fd1c4b05ea2e7d28";
    sha256 = "0sifr3bkmhyr5s6ljgfyr0fw6w49ajf11rlp1r797f3r3r6j9w4k";
  };

  dontFixup = true;
  # no "make install", gnulib is a collection of source code
  installPhase = ''
    mkdir -p $out; mv * $out/
    ln -s $out/lib $out/include
    mkdir -p $out/bin
    ln -s $out/gnulib-tool $out/bin/
  '';

  meta = {
    homepage = https://www.gnu.org/software/gnulib/;
    description = "Central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
