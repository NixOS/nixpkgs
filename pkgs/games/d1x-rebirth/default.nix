{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, physfs, SDL_mixer }:

stdenv.mkDerivation rec {
  name = "d1x-rebirth-0.57.3";
  src = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/d1x-rebirth_v0.57.3-src.tar.gz";
    sha256 = "07dbjza5flsczdsas0adb5xhn13gmhlpixa8ycp8hjm20y9kw1za";
  };

  buildInputs = [ scons pkgconfig SDL mesa physfs SDL_mixer ];

  installPhase = ''
    scons prefix=$out install
  '';

  meta = {
    homepage = http://www.dxx-rebirth.com/;
    description = "Source Port of the Descent 1 engine";
    license = "BSD"; # Parallax license, like BSD I think
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
