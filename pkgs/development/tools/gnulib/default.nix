{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20190326";

  src = fetchgit {
    url = https://git.savannah.gnu.org/r/gnulib.git;
    rev = "a18f7ce3c0aa760c33d46bbeb8e5b3a14cf24984";
    sha256 = "04py5n3j17wyqv9wfsslcrxzapni9vmw6p5g0adzy2md3ygjw4x4";
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
