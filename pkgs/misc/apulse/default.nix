{ stdenv, fetchurl, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/i-rinat/apulse/archive/v${version}.tar.gz";
    sha256 = "02906a8iwwjzzkjvhqqai2yd1636cgz9vl69vwq0vkv2v6cn21ky";
  };

  buildInputs =
    [ alsaLib cmake pkgconfig glib ];

  meta = with stdenv.lib; {
    description = "PulseAudio emulation for ALSA.";
    homepage = "https://github.com/i-rinat/apulse";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
