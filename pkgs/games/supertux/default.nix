{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, boost
, curl
, SDL2
, SDL2_image
, libSM
, libXext
, libpng
, freetype
, libGLU
, libGL
, glew
, glm
, openal
, libogg
, libvorbis
}:

stdenv.mkDerivation rec {
  pname = "supertux";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "1xkr3ka2sxp5s0spp84iv294i29s1vxqzazb6kmjc0n415h0x57p";
  };

  postPatch = ''
    sed '1i#include <memory>' -i external/partio_zip/zip_manager.hpp # gcc12
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    boost
    curl
    SDL2
    SDL2_image
    libSM
    libXext
    libpng
    freetype
    libGL
    libGLU
    glew
    glm
    openal
    libogg
    libvorbis
  ];

  cmakeFlags = [ "-DENABLE_BOOST_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = "https://supertux.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    mainProgram = "supertux2";
  };
}
