{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, libsForQt5, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    # We don't reference the revision by the appropriate tag (v2.1) here,
    # as the version of that tag still has the old version number in the
    # relevant header file. This would cause a bad user experience, as
    # "Help > About" would still display the old version number even though
    # we indeed ship the new version 2.1.
    rev = "97c2a2a7ecae12bf376558997805c24c3b6e3e07";
    sha256 = "0sbgijbln18gac9989x484r62jlxyagkq0ap0fvzislrkac4z3y9";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase libsForQt5.poppler ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
      For preview support the texlive package 'preview' has to be installed.
    '';
    homepage = https://tikzit.github.io/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.iblech maintainers.mgttlinger ];
  };
}
