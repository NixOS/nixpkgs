{ stdenv, fetchurl, cpio, zlib, bzip2, file, elfutils, libarchive, nspr, nss, popt, db, xz, python, lua, pkgconfig, binutils, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "rpm-${version}";
  version = "4.13.0.1";

  src = fetchurl {
    url = "http://ftp.rpm.org/releases/rpm-4.13.x/rpm-${version}.tar.bz2";
    sha256 = "27fc7ba7d419622b1ce34d6507aa70b0808bc344021d298072a0c2ec165f9b0d";
  };

  outputs = [ "out" "dev" "man" ];

  buildInputs = [ cpio zlib bzip2 file libarchive nspr nss db xz python lua pkgconfig autoreconfHook ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt elfutils nss db bzip2 libarchive binutils ];

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  configureFlags = [
    "--with-external-db"
    "--with-lua"
    "--enable-python"
    "--localstatedir=/var"
    "--sharedstatedir=/com"
  ];

  patches = [ ./rpm-4.13.0.1-bfd-config.patch ];

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

    # symlinks produced by build are incorrect
    ln -sf $out/bin/{rpm,rpmquery}
    ln -sf $out/bin/{rpm,rpmverify}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.rpm.org/;
    license = licenses.gpl2;
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ mornfall copumpkin ];
    platforms = platforms.linux;
  };
}
