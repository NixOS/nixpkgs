{ lib, stdenv, fetchurl, alsa-lib, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.8.0";

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "027hlqji0h2cm96rb8qvkdmwxl56l59bgn828nvmwak2c2i5k703";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
