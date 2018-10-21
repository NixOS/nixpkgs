{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0-rc3";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "24fbb3b7aca8dd5b957397a046d3cb71a00b324c";
    sha256 = "03wycizv1d42zrb8irj2zqkqhdsvwkjcwxympqqcg11apicqv252";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase ];

  preBuild = ''
    PREFIX=$out qmake
  '';

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
