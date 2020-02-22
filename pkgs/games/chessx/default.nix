{ mkDerivation
, stdenv
, pkgconfig
, zlib
, qtbase
, qtsvg
, qttools
, qtmultimedia
, qmake
, fetchurl
}:

mkDerivation rec {
  pname = "chessx";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "09rqyra28w3z9ldw8sx07k5ap3sjlli848p737maj7c240rasc6i";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtsvg
    qttools
    zlib
  ];

  # RCC: Error in 'resources.qrc': Cannot find file 'i18n/chessx_da.qm'
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/share/applications"
    cp -pr release/chessx "$out/bin"
    cp -pr unix/chessx.desktop "$out/share/applications"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://chessx.sourceforge.net/;
    description = "ChessX allows you to browse and analyse chess games";
    license = licenses.gpl2;
    maintainers = [ maintainers.luispedro ];
    platforms = platforms.linux;
  };
}
