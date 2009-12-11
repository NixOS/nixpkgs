{stdenv, fetchurl, libjpeg, libX11}:

stdenv.mkDerivation {
  name = "mjpegtools-1.9.0rc3";
  src = fetchurl {
    url = mirror://sourceforge/mjpeg/mjpegtools-1.9.0rc3.tar.gz;
    sha256 = "1xvgqzdb2rw6j4ss65k4hrzrbsl74p7k5l4qgf5dbfcw522kw7lb";
  };
  buildInputs = [libjpeg libX11];
  patches = [ ( fetchurl {
      url = "http://bugs.gentoo.org/attachment.cgi?id=145622";
      sha256 = "0c3bdrkr0qsrd3jybzz84z9gs4bq90rvxg87ffw08149v5qjz7a1";
      name = "patch.patch";
  } ) ]; # from gentoo. Don't know why it broke. Make it compile again.
}
