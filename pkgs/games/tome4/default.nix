{stdenv, fetchurl, openal, libvorbis, mesa_glu, premake4, SDL2, SDL2_image, SDL2_ttf}:

stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "tome4-${version}";
  src = fetchurl {
    url = "http://te4.org/dl/t-engine/t-engine4-src-${version}.tar.bz2";
    sha256 = "12pi2lw1k6l3p209nnkh4nfv3ppp8kpd6mkh1324c81z6mh6w4wg";
  };
  buildInputs = [ mesa_glu openal libvorbis SDL2 SDL2_ttf SDL2_image premake4 ];
  preConfigure = ''
    sed -e "s@/opt/SDL-2.0/include/SDL2@${SDL2}/include/SDL2@g" -e "s@/usr/include/GL@/run/opengl-driver/include@g" -i premake4.lua
    premake4 gmake
  '';
  makeFlags = [ "config=release" ];
  installPhase = ''
    install -Dm755 t-engine $out/opt/tome4/t-engine
    echo "cd $out/opt/tome4" >> tome4
    echo "./t-engine &" >> tome4
    install -Dm755 tome4 $out/bin/tome4
    cp -r bootstrap $out/opt/tome4
    cp -r game $out/opt/tome4
  '';
  meta = {
    homepage = "http://te4.org/";
    description = "Tales of Maj'eyal (rogue-like game)";
    maintainers = [ stdenv.lib.maintainers.chattered  ];
    license = stdenv.lib.licenses.gpl3;
  };
}
