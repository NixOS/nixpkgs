{ lib, stdenv, fetchurl, cmake, pkg-config, SDL2, SDL2_image , curl
, libogg, libvorbis, libGLU, libGL, openal, boost, glew
, libpng, freetype
}:

stdenv.mkDerivation rec {
  pname = "supertux";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "167m3z4m8n76dvbv42m1fnvabpbpsxvr28zk9641916jl9pfba96";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ SDL2 SDL2_image curl libogg libvorbis libGLU libGL openal boost glew
    libpng freetype
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
