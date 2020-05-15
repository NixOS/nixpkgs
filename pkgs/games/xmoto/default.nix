{ stdenv, fetchurl, chipmunk, sqlite, curl, zlib, bzip2, libjpeg
, libpng, freeglut, libGLU, libGL, SDL, SDL_mixer, SDL_image, SDL_net
, SDL_ttf, lua5, ode, libxdg_basedir, libxml2 }:

stdenv.mkDerivation rec {
  pname = "xmoto";
  version = "0.5.11";

  src = fetchurl {
    url = "https://download.tuxfamily.org/xmoto/xmoto/${version}/xmoto-${version}-src.tar.gz";
    sha256 = "1ci6r8zd0l7z28cy92ddf9dmqbdqwinz2y1cny34c61b57wsd155";
  };

  buildInputs = [
    chipmunk sqlite curl zlib bzip2 libjpeg libpng
    freeglut libGLU libGL SDL SDL_mixer SDL_image SDL_net SDL_ttf
    lua5 ode libxdg_basedir libxml2
  ];

  CXXFLAGS = [
    "-fpermissive"
    # Build using the old C++ ABI to fix issue with missing text; the issue
    # should be fixed in the next stable release (if that ever does happen)
    "-D_GLIBCXX_USE_CXX11_ABI=0"
  ];

  meta = with stdenv.lib; {
    description = "Obstacled race game";
    homepage = "http://xmoto.tuxfamily.org";
    maintainers = with maintainers; [ raskin pSub ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
