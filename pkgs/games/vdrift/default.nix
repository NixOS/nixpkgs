{ fetchurl, stdenv, mesa, SDL, scons, freeglut, SDL_image, glew, libvorbis,
  asio, boost, SDL_gfx, pkgconfig, bullet, curl, libarchive }:

stdenv.mkDerivation rec {
  version = "2012-07-22";
  name = "vdrift-${version}";
  patch = "c"; # see https://github.com/VDrift/vdrift/issues/110

  src = fetchurl {
    url = "mirror://sourceforge/vdrift/${name}.tar.bz2";
    sha256 = "1yqkc7y4s4g5ylw501bf0c03la7kfddjdk4yyi1xkcwy3pmgw2al";
  };

  patches = fetchurl {
    url = "mirror://sourceforge/vdrift/${name}${patch}_patch.diff";
    sha256 = "08mfg4xxkzyp6602cgqyjzc3rn0zsaa3ddjkpd44b83drv19lriy";
  };
  patchFlags = "-p0";

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
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
