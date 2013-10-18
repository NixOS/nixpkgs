{stdenv, fetchurl, SDL, SDL_image, mesa, cmake, physfs, boost, zip, zlib}:
stdenv.mkDerivation rec {
  version = "1.0-rc3";
  name = "blobby-volley-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/blobby/Blobby%20Volley%202%20%28Linux%29/1.0RC3/blobby2-linux-1.0rc3.tar.gz";
    sha256 = "10f50b2ygw8cb9mp33wpdwv9p6lc10qlwc1xd44bbcby1d9v5ga5";
  };

  buildInputs = [SDL SDL_image mesa cmake physfs boost zip zlib];

  preConfigure = ''
    sed -re '1i#include <cassert>' -i src/CrossCorrelation.h
  '';

  meta = {
    description = ''A blobby volleyball game'';
    license = with stdenv.lib.licenses; bsd3;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
