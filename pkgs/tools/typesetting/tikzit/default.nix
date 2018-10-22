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

  # TikZiT checks for updates by fetching a certain HTTP URL.
  # The security impact of not fetching over HTTPS is minimal, since TikZiT
  # uses the response only to display an information box, but it's probably
  # still better to follow best practices and fetch over HTTPS.
  #
  # This fix is not yet contained in upstream because of difficulties with Qt
  # and SSL on Ubuntu, see https://github.com/tikzit/tikzit/pull/34.
  preBuild = ''
    sed -ie 's+http://tikzit.github.io/+https://tikzit.github.io/+' src/tikzit.cpp
  '';

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
