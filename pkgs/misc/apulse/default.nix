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

stdenv.mkDerivation rec {
  pname = "apulse";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p6fh6ah5v3qz7dxhcsixx38bxg44ypbim4m03bxk3ls5i9xslmn";
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

  meta = with lib; {
    description = "PulseAudio emulation for ALSA";
    homepage = "https://github.com/i-rinat/apulse";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
    mainProgram = "apulse";
  };
}
