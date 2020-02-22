{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20200222";

  src = fetchgit {
    url = https://git.savannah.gnu.org/r/gnulib.git;
    rev = "d571f0dca66b9347251d78b4c9085fefb78eddb3";
    sha256 = "06mn7cwhq3k1jg49gqnv1sf248mji05h0fjhnrzrfhp9n7p26axp";
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
