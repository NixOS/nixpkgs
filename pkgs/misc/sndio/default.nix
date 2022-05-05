{ lib, stdenv, fetchurl, alsa-lib, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.8.1";

  src = fetchurl {
    url = "https://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "08b33bbrhbva1lyzzsj5k6ggcqzrfjfhb2n99a0b8b07kqc3f7gq";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  postInstall = ''
    install -Dm644 contrib/sndiod.service $out/lib/systemd/system/sndiod.service
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.all;
  };
}
