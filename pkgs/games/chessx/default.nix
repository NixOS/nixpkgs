{ stdenv, pkgconfig, pkgs, qt5, fetchurl }:
pkgs.stdenv.mkDerivation {
  name = "chessx";
  src = fetchurl {
    url = mirror://sourceforge/chessx/chessx-1.2.2.tgz;
    sha256 = "85fe797e329d8a2bb54101f602ddd00f2c19a50873492ebefd22519956641caa";
  };
  preConfigure = ''
    qmake -spec linux-g++ chessx.pro
  '';
  buildInputs = [
        stdenv
        pkgconfig
        qt5.base
        qt5.svg
        qt5.tools

        pkgs.zlib
  ];
  enableParallelBuilding = true;
  installPhase = ''
      mkdir -p "$out/bin"
      cp -pr release/chessx "$out/bin"
  '';
}
