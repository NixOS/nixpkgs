{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, nspr, nss, popt, db4 }:

stdenv.mkDerivation rec {
  name = "rpm-4.7.2";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.7.x/${name}.tar.bz2";
    sha1 = "07b90f653775329ea726ce0005c4c82f56167ca0";
  };

  buildInputs = [ cpio zlib bzip2 file nspr nss popt db4 ];

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss -I${elfutils}/include";

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";
  
  configureFlags = "--with-external-db --without-lua";

  meta = {
    homepage = http://www.rpm.org/;
    license = "GPLv2";
    description = "The RPM Package Manager";
  };
}
