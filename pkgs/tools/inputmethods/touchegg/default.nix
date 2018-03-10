{ stdenv, fetchurl, xorg, xorgserver, qt4, libGLU_combined, geis, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "touchegg-${version}";
  version = "1.1.1";
  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/touchegg/${name}.tar.gz";
    sha256 = "95734815c7219d9a71282f3144b3526f2542b4fa270a8e69d644722d024b4038";
  };

  buildInputs = [ xorgserver libGLU_combined xorg.libX11 xorg.libXtst xorg.libXext qt4 geis ];

  nativeBuildInputs = [ qmake4Hook ];

  preConfigure = ''
    sed -e "s@/usr/@$out/@g" -i $(find . -name touchegg.pro)
    sed -e "s@/usr/@$out/@g" -i $(find ./src/touchegg/config/ -name Config.cpp)
  '';

  meta = {
    homepage = https://github.com/JoseExposito/touchegg;
    description = "Macro binding for touch surfaces";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
