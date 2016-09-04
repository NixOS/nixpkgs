{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, physfs, SDL_mixer }:

stdenv.mkDerivation rec {
  name = "d2x-rebirth-0.58.1";
  src = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/d2x-rebirth_v0.58.1-src.tar.gz";
    sha256 = "08mg831afc1v068c0ds70lhmxk8a54494jls7s9hwf02ffhv3sx8";
  };

  buildInputs = [ scons pkgconfig SDL mesa physfs SDL_mixer ];

  installPhase = ''
    scons prefix=$out install
  '';

  meta = {
    homepage = http://www.dxx-rebirth.com/;
    description = "Source Port of the Descent 2 engine";
    license = stdenv.lib.licenses.unfree;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
