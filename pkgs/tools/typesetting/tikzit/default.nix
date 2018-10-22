{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0-rc3";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "fcc77f8b47882a77a9fced1e131fc6db092db749";
    sha256 = "0xlk7k464s0f06bnkdj7jzdrhmxxsr0304zi7rgl6x5mgs022jk1";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    description = "A graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
    '';
    homepage = https://tikzit.github.io/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.iblech maintainers.mgttlinger ];
  };
}
