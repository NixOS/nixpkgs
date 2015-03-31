{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${version}";
    sha256 = "0ypirj7srdspbqhgi74a4blmb1g4sgvz96abw4m8y1fils4ysdgj";
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
