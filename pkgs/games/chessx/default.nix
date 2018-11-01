{ stdenv, pkgconfig, zlib, qtbase, qtsvg, qttools, qtmultimedia, qmake, fetchurl, makeWrapper
, lib
}:

stdenv.mkDerivation rec {
  name = "chessx-${version}";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "1vb838byzmnyglm9mq3khh3kddb9g4g111cybxjzalxxlc81k5dd";
  };

  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtmultimedia
    zlib
  ];

  nativeBuildInputs = [ pkgconfig qmake makeWrapper ];

  # RCC: Error in 'resources.qrc': Cannot find file 'i18n/chessx_da.qm'
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/share/applications"
    cp -pr release/chessx "$out/bin"
    cp -pr unix/chessx.desktop "$out/share/applications"

    wrapProgram $out/bin/chessx \
      --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-5.${lib.versions.minor qtbase.version}/plugins

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://chessx.sourceforge.net/;
    description = "ChessX allows you to browse and analyse chess games";
    license = licenses.gpl2;
    maintainers = [maintainers.luispedro];
    platforms = platforms.linux;
  };
}
