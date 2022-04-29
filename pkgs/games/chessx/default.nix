{ mkDerivation
, lib
, pkg-config
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
  version = "1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "sha256-wadIO3iNvj8LgIzExHTmeXxXnWOI+ViLrdhAlzZ79Jw=";
  };

  nativeBuildInputs = [
    pkg-config
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

  meta = with lib; {
    homepage = "http://chessx.sourceforge.net/";
    description = "Browse and analyse chess games";
    license = licenses.gpl2;
    maintainers = [ maintainers.luispedro ];
    platforms = platforms.linux;
  };
}
