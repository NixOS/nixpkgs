{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sndio";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.sndio.org/sndio-${finalAttrs.version}.tar.gz";
    hash = "sha256-8wgm/JwH42nTkk1fzt9qClPA30rh9atQ/pzygFQPaZo=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;
  configurePlatforms = [ ];

  postInstall = ''
    install -Dm644 contrib/sndiod.service $out/lib/systemd/system/sndiod.service
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ Madouura ];
    platforms = lib.platforms.all;
  };
})
