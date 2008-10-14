{stdenv, fetchurl, libjpeg, libX11}:

stdenv.mkDerivation {
  name = "mjpegtools-1.6.2";
  src = fetchurl {
    url = mirror://sourceforge/mjpeg/mjpegtools-1.9.0rc3.tar.gz;
    sha256 = "1xvgqzdb2rw6j4ss65k4hrzrbsl74p7k5l4qgf5dbfcw522kw7lb";
  };
  buildInputs = [libjpeg libX11];
}
