{ stdenv, pkgconfig, zlib, qtbase, qtsvg, qttools, qtmultimedia, qmakeHook, fetchurl }:
stdenv.mkDerivation rec {
  name = "chessx-${version}";
  version = "1.3.2";
  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${version}.tgz";
    sha256 = "b136cf56d37d34867cdb9538176e1703b14f61b3384885b6f100580d0af0a3ff";
  };
  buildInputs = [
   stdenv
   pkgconfig
   qtbase
   qtsvg
   qttools
   qtmultimedia
   zlib
   qmakeHook
  ];

  enableParallelBuilding = true;
  installPhase = ''
      mkdir -p "$out/bin"
      mkdir -p "$out/share/applications"
      cp -pr release/chessx "$out/bin"
      cp -pr unix/chessx.desktop "$out/share/applications"
  '';

  meta = with stdenv.lib; {
    homepage = http://chessx.sourceforge.net/;
    description = "ChessX allows you to browse and analyse chess games";
    license = licenses.gpl2;
    maintainers = [maintainers.luispedro];
  };
}
