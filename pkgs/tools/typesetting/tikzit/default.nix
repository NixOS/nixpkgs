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

  preBuild = ''
    sed -i '/DESTDIR/d' tikzit.pro
    echo "DESTDIR = build" >> tikzit.pro
    qmake
  '';

  # The default installPhase tries to install under
  # /nix/store/*-qtbase-*-dev/tests/tikzit. This is not what we want.
  installPhase = ''
    mkdir -p $out/bin
    cp -r $srcdir/build/source/build/* $out/bin/
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
