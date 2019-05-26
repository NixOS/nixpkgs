{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib
, tracingSupport ? true, logToStderr ? true }:

let oz = x: if x then "1" else "0"; in

stdenv.mkDerivation rec {
  pname = "apulse";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = pname;
    rev = "v${version}";
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
    homepage = "https://github.com/i-rinat/apulse";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
