{ stdenv, pkgconfig, zlib, qtbase, qtsvg, qttools, qtmultimedia, qmake, fetchurl }:
stdenv.mkDerivation rec {
  name = "chessx-${version}";
  version = "1.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "1x10c9idj2qks8xk9dy7aw3alc5w7z1kvv6dnahs0428j0sp4a74";
  };
  buildInputs = [
   qtbase
   qtsvg
   qttools
   qtmultimedia
   zlib
  ];
  nativeBuildInputs = [ pkgconfig qmake ];

  # RCC: Error in 'resources.qrc': Cannot find file 'i18n/chessx_da.qm'
  #enableParallelBuilding = true;

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
    maintainers = [maintainers.luispedro];
  };
}
