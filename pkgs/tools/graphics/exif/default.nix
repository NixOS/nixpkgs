{ stdenv, fetchurl, pkgconfig, libexif, popt }:

stdenv.mkDerivation rec {
  name = "exif-0.6.21";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "1zb9hwdl783d4vd2s2rw642hg8hd6n0mfp6lrbiqmp9jmhlq5rsr";
  };

  buildInputs = [ pkgconfig libexif popt ];
  
  meta = {
    homepage = http://libexif.sourceforge.net/;
    description = "A utility to read and manipulate EXIF data in digital photographs";
  };
}
