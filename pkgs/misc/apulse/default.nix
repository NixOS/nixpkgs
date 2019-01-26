{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib
, tracingSupport ? true, logToStderr ? true }:

let oz = x: if x then "1" else "0"; in

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.11.1";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "602b3a02b4b459d4652a3a0a836fab6f892d4080";
    sha256 = "0yk9vgb4aws8xnkhdhgpxp5c0rri8yq61yxk85j99j8ax806i3r8";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib glib ];

  cmakeFlags = [
    "-DWITH_TRACE=${oz tracingSupport}"
    "-DLOG_TO_STDERR=${oz logToStderr}"
  ];

  meta = with stdenv.lib; {
    description = "PulseAudio emulation for ALSA";
    homepage = https://github.com/i-rinat/apulse;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
