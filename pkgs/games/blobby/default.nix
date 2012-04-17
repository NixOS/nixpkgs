{stdenv, fetchurl, SDL, SDL_image, mesa, cmake, physfs, boost, zip, zlib}:
stdenv.mkDerivation rec {
  version = "2.0-RC1";
  name = "blobby-volley-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/blobby/Blobby%20Volley%202%20%28Linux%29/1.0RC1/blobby2-linux-1.0rc1.tar.gz";
    sha256 = "1cb56bd31vqkc12cmzp43q2aai99505isq2mii95jp0rzdqks4fy";
  };

  buildInputs = [SDL SDL_image mesa cmake physfs boost zip zlib];

  preConfigure = ''
    sed -re '1i#include <cassert>' -i src/CrossCorrelation.h
  '';

  meta = {
    description = ''A blobby volleyball game.'';
    license = with stdev.lib.licenses; bsd3;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
