{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "v${version}";
    sha256 = "0fwxr9rc9vmw2jzpj084rygzyhp4xm3vm737668az600ln2scyad";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
    '';
    homepage = https://tikzit.github.io/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.iblech maintainers.mgttlinger ];
  };
}
