{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, nspr, nss, popt, db, xz, python }:

stdenv.mkDerivation rec {
  name = "rpm-4.11.2";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.11.x/${name}.tar.bz2";
    sha256 = "1m2859js0dwg26sg2mnbkpzhvx303b12kx26az74cf5k6bk8sgs0";
  };

  buildInputs = [ cpio zlib bzip2 file nspr nss popt db xz python ];

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss -I${elfutils}/include";

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";
  
  configureFlags = "--with-external-db --without-lua --enable-python";

  meta = with stdenv.lib; {
    homepage = http://www.rpm.org/;
    license = licenses.gpl2;
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ mornfall ];
  };
}
