{ stdenv, fetchurl, chipmunk, sqlite, curl, zlib, bzip2, libjpeg
, libpng, freeglut, libGLU_combined, SDL, SDL_mixer, SDL_image, SDL_net
, SDL_ttf, lua5, ode, libxdg_basedir, libxml2 }:

stdenv.mkDerivation rec {
  name = "xmoto-${version}";
  version = "0.5.11";

  src = fetchurl {
    url = "http://download.tuxfamily.org/xmoto/xmoto/${version}/xmoto-${version}-src.tar.gz";
    sha256 = "1ci6r8zd0l7z28cy92ddf9dmqbdqwinz2y1cny34c61b57wsd155";
  };

  buildInputs = [
    chipmunk sqlite curl zlib bzip2 libjpeg libpng
    freeglut libGLU_combined SDL SDL_mixer SDL_image SDL_net SDL_ttf
    lua5 ode libxdg_basedir libxml2
  ];

  CXXFLAGS = [ "-fpermissive" ];

  meta = with stdenv.lib; {
    description = "Obstacled race game";
    homepage = http://xmoto.tuxfamily.org;
    maintainers = with maintainers; [ raskin viric pSub ];
    platforms = platforms.linux;
  };
}
