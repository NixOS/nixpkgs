{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0-rc3";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "d005c0ab40b98a5d91a85e288715d948d25c2274";
    sha256 = "1qbh1y9fgh947h27gifl3lz391sajdimaqadrf52m42b855b8qx3";
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
