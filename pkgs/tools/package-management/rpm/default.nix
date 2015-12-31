{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, libarchive, nspr, nss, popt, db, xz, python }:

stdenv.mkDerivation rec {
  name = "rpm-4.12.0";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.12.x/${name}.tar.bz2";
    sha256 = "18hk47hc755nslvb7xkq4jb095z7va0nlcyxdpxayc4lmb8mq3bp";
  };

  buildInputs = [ cpio zlib bzip2 file libarchive nspr nss popt db xz python ];

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss -I${elfutils}/include";

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";

  postPatch = ''
    # For Python3, the original expression evaluates as 'python3.4' but we want 'python3.4m' here
    substituteInPlace configure --replace 'python''${PYTHON_VERSION}' ${python.executable}
  '';

  configureFlags = "--with-external-db --without-lua --enable-python";

  meta = with stdenv.lib; {
    homepage = http://www.rpm.org/;
    license = licenses.gpl2;
    description = "The RPM Package Manager";
    maintainers = [ maintainers.mornfall ];
    platforms = platforms.linux;
  };
}
