{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20200223";

  src = fetchgit {
    url = https://git.savannah.gnu.org/r/gnulib.git;
    rev = "292fd5d6ff5ecce81ec3c648f353732a9ece83c0";
    sha256 = "0hkg3nql8nsll0vrqk4ifda0v4kpi67xz42r8daqsql6c4rciqnw";
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
