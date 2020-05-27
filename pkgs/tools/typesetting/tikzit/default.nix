{ stdenv, mkDerivation, fetchFromGitHub, qmake, qttools, qtbase, poppler, flex, bison }:

mkDerivation {
  pname = "tikzit";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "v2.1.5";
    sha256 = "1xrx7r8b6nb912k91pkdwaz2gijfq6lzssyqxard0591h2mycbcg";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase poppler ];

  # src/data/tikzlexer.l:29:10: fatal error: tikzparser.parser.hpp: No such file or directory
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "A graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
      For preview support the texlive package 'preview' has to be installed.
    '';
    homepage = "https://tikzit.github.io/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.iblech maintainers.mgttlinger ];
  };
}
