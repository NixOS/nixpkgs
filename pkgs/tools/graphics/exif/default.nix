{stdenv, fetchurl, pkgconfig, libexif, popt}:

stdenv.mkDerivation {
  name = "exif-0.6.9";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/libexif/exif-0.6.9.tar.gz;
    md5 = "555029098386fa677c461eb249d852d7";
  };

  buildInputs = [pkgconfig libexif popt];
}
