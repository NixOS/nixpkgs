{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, libarchive, nspr, nss, popt, db, xz, python, lua, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "rpm-4.12.0";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.12.x/${name}.tar.bz2";
    sha256 = "18hk47hc755nslvb7xkq4jb095z7va0nlcyxdpxayc4lmb8mq3bp";
  };

  buildInputs = [ cpio zlib bzip2 file libarchive nspr nss db xz python lua pkgconfig autoreconfHook ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt nss db bzip2 libarchive ];

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss -I${elfutils}/include";

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";

  postPatch = ''
    # For Python3, the original expression evaluates as 'python3.4' but we want 'python3.4m' here
    substituteInPlace configure --replace 'python''${PYTHON_VERSION}' ${python.executable}

    substituteInPlace Makefile.am --replace '@$(MKDIR_P) $(DESTDIR)$(localstatedir)/tmp' ""
  '';

  configureFlags = "--with-external-db --with-lua --enable-python --localstatedir=/var --sharedstatedir=/com";

  meta = with stdenv.lib; {
    homepage = http://www.rpm.org/;
    license = licenses.gpl2;
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ mornfall copumpkin ];
    platforms = platforms.linux;
  };
}
