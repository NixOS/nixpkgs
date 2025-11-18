{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  pkg-config,
  glib,
  tracingSupport ? true,
  logToStderr ? true,
}:

let
  oz = x: if x then "1" else "0";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "apulse";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SWvQvS9QBOevOSRpjY3XpyhzWoHAkXzkk8Mh4ovltNI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    glib
  ];

  cmakeFlags = [
    "-DWITH_TRACE=${oz tracingSupport}"
    "-DLOG_TO_STDERR=${oz logToStderr}"
  ];

  meta = {
    description = "PulseAudio emulation for ALSA";
    homepage = "https://github.com/i-rinat/apulse";
    changelog = "https://github.com/i-rinat/apulse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jagajaga ];
    mainProgram = "apulse";
  };
})
