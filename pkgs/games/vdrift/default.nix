{ fetchurl, stdenv, mesa, SDL, scons, freeglut, SDL_image, glew, libvorbis,
  asio, boost, SDL_gfx }:

stdenv.mkDerivation rec {
  name = "vdrift-2010-06-30";

  src = fetchurl {
    url = "mirror://sourceforge/vdrift/${name}.tar.bz2";
    sha256 = "1zbh62363gx4ayyx4wcsp5di4f16qqfg2ajwkgw71kss6j7lk71j";
  };

  buildInputs = [ scons mesa SDL freeglut SDL_image glew libvorbis asio boost
    SDL_gfx ];

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
