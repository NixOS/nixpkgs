{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.12.6";
  name    = "bindfs-${version}";

  src = fetchurl {
    url    = "http://bindfs.org/downloads/${name}.tar.gz";
    sha256 = "0s90n1n4rvpcg51ixr5wx8ixml1xnc7w28xlbnms34v19pzghm59";
  };

  dontStrip = true;

  buildInputs = [ fuse pkgconfig ];

  meta = {
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = http://bindfs.org;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
