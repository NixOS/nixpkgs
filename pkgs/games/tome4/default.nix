{stdenv, fetchurl, openal, libpng, libvorbis, mesa_glu, premake4, SDL2, SDL2_image, SDL2_ttf }:

stdenv.mkDerivation rec {
  version = "1.4.9";
  name = "tome4-${version}";
  src = fetchurl {
    url = "http://te4.org/dl/t-engine/t-engine4-src-${version}.tar.bz2";
    sha256 = "0c82m0g1ps64zghgdrp78m6bvfngcb75whhknqiailld7kz1g9xl";
  };
  nativeBuildInputs = [ premake4 ];
  buildInputs = [
    mesa_glu openal libpng libvorbis SDL2 SDL2_ttf SDL2_image
  ];
  NIX_CFLAGS_COMPILE = [
    "-I${SDL2_image}/include/SDL2"
    "-I${SDL2_ttf}/include/SDL2"
  ];
  preConfigure = ''
    substituteInPlace premake4.lua \
      --replace "/opt/SDL-2.0/include/SDL2" "${SDL2.dev}/include/SDL2" \
      --replace "/usr/include/GL" "/run/opengl-driver/include"
    premake4 gmake
  '';
  makeFlags = [ "config=release" ];
  installPhase = ''
    install -Dm755 t-engine $out/opt/tome4/t-engine
    cat > tome4 <<EOF
#!/bin/sh
cd $out/opt/tome4
./t-engine &
EOF
    install -Dm755 tome4 $out/bin/tome4
    cp -r bootstrap $out/opt/tome4
    cp -r game $out/opt/tome4
  '';
  meta = with stdenv.lib; {
    homepage = "http://te4.org/";
    description = "Tales of Maj'eyal (rogue-like game)";
    maintainers = [ maintainers.chattered ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
