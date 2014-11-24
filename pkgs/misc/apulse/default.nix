{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${version}";
    sha256 = "115z5a0n8lkcqfgz0cgvjw3p7d0nvzfxzd9g0h137ziflyx3ysh1";
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
