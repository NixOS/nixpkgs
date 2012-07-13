{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, nspr, nss, popt, db4, xz }:

stdenv.mkDerivation rec {
  name = "rpm-4.10.0";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.10.x/${name}.tar.bz2";
    sha256 = "1ag4pz51npiwf6vcksipjxaypm5afzmy8lj19bp0fk5n6mr26bhf";
  };

  buildInputs = [ cpio zlib bzip2 file nspr nss popt db4 xz ];

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
