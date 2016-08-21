{ stdenv, fetchurl, pkgconfig, fuse, zlib, glib }:

stdenv.mkDerivation rec {
  name = "fuseiso-20070708";

  src = fetchurl {
    url = "mirror://sourceforge/project/fuseiso/fuseiso/20070708/fuseiso-20070708.tar.bz2";
    sha1 = "fe142556ad35dd7e5dc31a16183232a6e2da7692";  
  };

  buildInputs = [ pkgconfig fuse zlib glib ];

  meta = {
    homepage = http://sourceforge.net/projects/fuseiso;
    description = "FUSE module to mount ISO filesystem images";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
