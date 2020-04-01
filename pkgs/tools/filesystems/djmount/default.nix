{ stdenv, fetchurl, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  pname = "djmount";
  version = "0.71";
  src = fetchurl {
    url = "mirror://sourceforge/djmount/${version}/${pname}-${version}.tar.gz";
    sha256 = "0kqf0cy3h4cfiy5a2sigmisx0lvvsi1n0fbyb9ll5gacmy1b8nxa";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse];

  meta = {
    homepage = "http://djmount.sourceforge.net/";
    description = "UPnP AV client, mounts as a Linux filesystem the media content of compatible UPnP AV devices";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
    license = stdenv.lib.licenses.gpl2;
  };
}
