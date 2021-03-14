{ lib, stdenv, fetchgit, python3 }:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20200223";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/r/gnulib.git";
    rev = "292fd5d6ff5ecce81ec3c648f353732a9ece83c0";
    sha256 = "0hkg3nql8nsll0vrqk4ifda0v4kpi67xz42r8daqsql6c4rciqnw";
  };

  postPatch = ''
    patchShebangs gnulib-tool.py
  '';

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # do not change headers to not update all vendored build files
  dontFixup = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gnulib/";
    description = "Central location for code to be shared among GNU packages";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
