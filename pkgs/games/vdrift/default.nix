{ fetchurl, stdenv, mesa, SDL, scons, freeglut, SDL_image, glew, libvorbis,
  asio, boost, SDL_gfx, pkgconfig, bullet, curl, libarchive }:

stdenv.mkDerivation rec {
  name = "vdrift-2011-10-22";

  src = fetchurl {
    url = "mirror://sourceforge/vdrift/${name}.tar.bz2";
    sha256 = "0vg1v1590jbln6k236kxn2sfgclvc6g34kykhh4nq9q3l1xgy38s";
  };

  buildInputs = [ scons mesa SDL freeglut SDL_image glew libvorbis asio boost
    SDL_gfx pkgconfig bullet curl libarchive ];

  buildPhase = ''
    sed -i -e s,/usr/local,$out, SConstruct
    scons
  '';
  installPhase = "scons install";

  meta = {
    description = "Car racing game";
    homepage = http://vdrift.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
