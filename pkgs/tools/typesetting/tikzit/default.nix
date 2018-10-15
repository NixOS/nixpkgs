{ stdenv, fetchFromGitHub, qmake, qttools, qtbase, flex, bison }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0-rc2";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "v${version}";
    sha256 = "119cc8p82cf78rha711zxm4pzmazwgiv81w2qbwwwxd2mkhjwflx";
  };

  nativeBuildInputs = [ qmake qttools flex bison ];
  buildInputs = [ qtbase ];

  # The default installPhase tries to install under
  # /nix/store/*-qtbase-*-dev/tests/tikzit. This is not what we want.
  installPhase = ''
    mkdir -p $out/bin
    cp tikzit $out/bin
  '';

  meta = with stdenv.lib; {
    description = "a graphical editor for TikZ diagrams";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
    '';
    homepage = https://tikzit.github.io/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.iblech ];
  };
}
