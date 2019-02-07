{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image , curl
, libogg, libvorbis, libGLU_combined, openal, boost, glew
, libpng, freetype
}:

stdenv.mkDerivation rec {
  name = "supertux-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "1h1s4abirkdv4ag22zvyk6zkk64skqbjmcnnba67ps4hdzxfbhy4";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ SDL2 SDL2_image curl libogg libvorbis libGLU_combined openal boost glew
    libpng freetype
  ];

  cmakeFlags = [ "-DENABLE_BOOST_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = http://supertux.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
