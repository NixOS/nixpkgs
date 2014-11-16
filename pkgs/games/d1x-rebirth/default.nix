{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, physfs, SDL_mixer }:

stdenv.mkDerivation rec {
  name = "d1x-rebirth-0.58.1";
  src = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/d1x-rebirth_v0.58.1-src.tar.gz";
    sha256 = "13p3nfqaa78h6bl0k8mdsn90ai99wbqaj6qlsjsgsn8imficivsv";
  };

  buildInputs = [ scons pkgconfig SDL mesa physfs SDL_mixer ];

  installPhase = ''
    scons prefix=$out install
  '';

  meta = {
    homepage = http://www.dxx-rebirth.com/;
    description = "Source Port of the Descent 1 engine";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
