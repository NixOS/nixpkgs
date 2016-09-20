{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, libarchive, nspr, nss, popt, db, xz, python, lua, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "rpm-4.12.0";

  src = fetchurl {
    url = "http://rpm.org/releases/rpm-4.12.x/${name}.tar.bz2";
    sha256 = "18hk47hc755nslvb7xkq4jb095z7va0nlcyxdpxayc4lmb8mq3bp";
  };

  outputs = [ "out" "dev" "man" ];

  buildInputs = [ cpio zlib bzip2 file libarchive nspr nss db xz python lua pkgconfig autoreconfHook ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt elfutils nss db bzip2 libarchive ];

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  configureFlags = [
    "--with-external-db"
    "--with-lua"
    "--enable-python"
    "--localstatedir=/var"
    "--sharedstatedir=/com"
  ];

  postPatch = ''
    # For Python3, the original expression evaluates as 'python3.4' but we want 'python3.4m' here
    substituteInPlace configure.ac --replace 'python''${PYTHON_VERSION}' ${python.executable}

    substituteInPlace Makefile.am --replace '@$(MKDIR_P) $(DESTDIR)$(localstatedir)/tmp' ""
  '';

  preFixup = ''
    # Don't keep a reference to RPM headers or manpages
    for f in $out/lib/rpm/platform/*/macros; do
      substituteInPlace $f --replace "$dev" "/rpm-dev-path-was-here"
      substituteInPlace $f --replace "$man" "/rpm-man-path-was-here"
    done

    # Avoid macros like '%__ld' pointing to absolute paths
    for tool in ld nm objcopy objdump strip; do
      sed -i $out/lib/rpm/macros -e "s/^%__$tool.*/%__$tool $tool/"
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.rpm.org/;
    license = licenses.gpl2;
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ mornfall copumpkin ];
    platforms = platforms.linux;
  };
}
