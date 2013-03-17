{ stdenv, fetchurl, SDL, SDL_image, mesa, cmake, physfs, boostHeaders
, zip, zlib/*, lua5, tinyxml*/ }:

stdenv.mkDerivation rec {
  version = "1.0rc3";
  name = "blobby-volley-2-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/blobby/blobby2-linux-${version}.tar.gz";
    sha256 = "10f50b2ygw8cb9mp33wpdwv9p6lc10qlwc1xd44bbcby1d9v5ga5";
  };

  buildInputs = [
    SDL SDL_image mesa cmake physfs boostHeaders
    zip zlib # lua5 tinyxml # ToDo: use shared libs?
  ];

  preConfigure = ''
    sed -re '1i#include <cassert>' -i src/CrossCorrelation.h
  '';

  meta = {
    description = ''A blobby volleyball game.'';
    license = with stdenv.lib.licenses; bsd3;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
