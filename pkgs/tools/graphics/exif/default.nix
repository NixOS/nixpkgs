{stdenv, fetchurl, pkgconfig, libexif, popt}:

stdenv.mkDerivation {
  name = "exif-0.6.15";

  src = fetchurl {
    url = mirror://sourceforge/libexif/exif-0.6.15.tar.bz2;
    sha256 = "19kxl72l1iqq747k58rir7v4ld1676j3dmjdc1pik9hjlgdb1yj1";
  };

  buildInputs = [pkgconfig libexif popt];
}
