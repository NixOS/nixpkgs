{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${version}";
    sha256 = "0b384dr415flxk3n4abfwfljlh7vvr1g9gad15zc5fgbyxsinv12";
  };

  buildInputs =
    [ alsaLib cmake pkgconfig glib ];

  meta = with stdenv.lib; {
    description = "PulseAudio emulation for ALSA";
    homepage = "https://github.com/i-rinat/apulse";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
