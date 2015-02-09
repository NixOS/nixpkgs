{ stdenv, fetchurl, xlibs, xorgserver, qt4, mesa, geis  }:

stdenv.mkDerivation rec {
  name = "touchegg-${version}";
  version = "1.1.1";
  src = fetchurl {
    url = "https://touchegg.googlecode.com/files/${name}.tar.gz";
    sha256 = "95734815c7219d9a71282f3144b3526f2542b4fa270a8e69d644722d024b4038";
  };

  buildInputs = [ xorgserver mesa xlibs.libX11 xlibs.libXtst xlibs.libXext qt4 geis ];

  configurePhase = ''
    sed -e "s@/usr/@$out/@g" -i $(find . -name touchegg.pro)
    sed -e "s@/usr/@$out/@g" -i $(find ./src/touchegg/config/ -name Config.cpp)
    qmake touchegg.pro
  '';

  meta = {
    homepage = "https://code.google.com/p/touchegg/";
    description = "Macro binding for touch surfaces";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}