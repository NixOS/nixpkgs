{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20190811";

  src = fetchgit {
    url = https://git.savannah.gnu.org/r/gnulib.git;
    rev = "6430babe47ece6953cf18ef07c1d8642c8588e89";
    sha256 = "14kgykbjly03dlb25sllcfcrpk7zkypa449gr3zbqv4rhpmnzizg";
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
