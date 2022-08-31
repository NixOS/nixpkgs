{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, SDL2
, SDL2_image
, curl
, libogg
, libvorbis
, libGLU
, libGL
, libSM
, libICE
, libXext
, openal
, boost
, glew
, libpng
, freetype
, glm
}:

stdenv.mkDerivation rec {
  pname = "supertux";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "1xkr3ka2sxp5s0spp84iv294i29s1vxqzazb6kmjc0n415h0x57p";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    SDL2
    SDL2_image
    curl
    libogg
    libvorbis
    libGLU
    libGL
    libSM
    libICE
    libXext
    openal
    boost
    glew
    libpng
    freetype
    glm
  ];

  cmakeFlags = [ "-DENABLE_BOOST_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = "http://supertux.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
