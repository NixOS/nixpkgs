{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image , curl
, libogg, libvorbis, mesa, openal, boost, glew
}:

stdenv.mkDerivation rec {
  name = "supertux-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/SuperTux/supertux/releases/download/v${version}/SuperTux-v${version}-Source.tar.gz";
    sha256 = "0fx7c7m6mfanqy7kln7yf6abb5l3r68picf32js2yls11jj0vbng";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ SDL2 SDL2_image curl libogg libvorbis mesa openal boost glew ];

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
