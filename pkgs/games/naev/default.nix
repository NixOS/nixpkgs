{ fetchurl, stdenv, lua5, SDL, openal, SDL_mixer, libxml2, pkgconfig, libvorbis
, libpng, mesa, makeWrapper }:

stdenv.mkDerivation {
  name = "naev-0.5.0beta1";

  srcData = fetchurl {
    url = http://naev.googlecode.com/files/ndata-0.5.0-beta1;
    sha256 = "0pqys1wdlxa336i9gjxfkgnq42xrbvq58ym66y0aa9xm92vr53f6";
  };

  src = fetchurl {
    url = http://naev.googlecode.com/files/naev-0.5.0-beta1.tar.bz2;
    sha256 = "1nkwjclfjypgdcfbfqkiidsvi0zfjvkcj0dgnrbj1g11rr6kd3wm";
  };

  buildInputs = [ SDL lua5 SDL_mixer openal libxml2 pkgconfig libvorbis
    libpng mesa makeWrapper ];

  postInstall = ''
    ensureDir $out/share/naev
    cp $srcData $out/share/naev/ndata
    wrapProgram $out/bin/naev --add-flags $out/share/naev/ndata
  '';

  meta = {
    description = "2D action/rpg space game";
    homepage = http://www.naev.org;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
