{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, physfs, SDL_mixer }:

stdenv.mkDerivation rec {
  name = "d2x-rebirth-0.57.3";
  src = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/d2x-rebirth_v0.57.3-src.tar.gz";
    sha256 = "0yyandmxz12bbpnd746nddjlqh5i7dylwm006shixis3w3giz77c";
  };

  buildInputs = [ scons pkgconfig SDL mesa physfs SDL_mixer ];

  installPhase = ''
    scons prefix=$out install
  '';

  meta = {
    homepage = http://www.dxx-rebirth.com/;
    description = "Source Port of the Descent 2 engine";
    license = "BSD"; # Parallax license, like BSD I think
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
