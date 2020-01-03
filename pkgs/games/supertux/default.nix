{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image , curl
, libogg, libvorbis, libGLU, libGL, openal, boost, glew
, libpng, freetype
}:

stdenv.mkDerivation rec {
  pname = "supertux";
  version = "0.6.1.1";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "0n36qxwjlkdlksximz4s729az6pry2sdjavwgm7m65vfgdiz139f";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ SDL2 SDL2_image curl libogg libvorbis libGLU libGL openal boost glew
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
