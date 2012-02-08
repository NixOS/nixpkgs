{ stdenv, fetchurl, pkgconfig, fuse, libzip, zlib }:

stdenv.mkDerivation rec {
  name = "fuse-zip-0.2.13";
  
  src = fetchurl {
    url = "http://fuse-zip.googlecode.com/files/${name}.tar.gz";
    sha1 = "9cfa00e38a59d4e06fd47bfaca75ad5e299ecc6b";
  };

  buildInputs = [ pkgconfig fuse libzip zlib ];

  makeFlags = "INSTALLPREFIX=$(out)";
  
  meta = {
    homepage = http://code.google.com/p/fuse-zip/;
    description = "A FUSE-based filesystem that allows read and write access to ZIP files";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
