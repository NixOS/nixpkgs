{stdenv, fetchurl, fuse, curl, pkgconfig, glib, zlib}:

stdenv.mkDerivation {
  name = "curlftpfs-0.9.1";
  src = fetchurl {
    url = mirror://sourceforge/curlftpfs/curlftpfs-0.9.1.tar.gz;
    sha256 = "9f50cdf02c0dc31ef148410345b2374d294d8853d2dae11775e36b0268ad227d";
  };
  buildInputs = [fuse curl pkgconfig glib zlib];
}
