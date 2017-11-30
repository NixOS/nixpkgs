{ stdenv
, pkgconfig, autoreconfHook
, fetchurl, cpio, zlib, bzip2, file, elfutils, libbfd, libarchive, nspr, nss, popt, db, xz, python, lua
}:

stdenv.mkDerivation rec {
  name = "rpm-${version}";
  version = "4.14.0";

  src = fetchurl {
    url = "http://ftp.rpm.org/releases/rpm-4.14.x/rpm-${version}.tar.bz2";
    sha256 = "053396glswgszzg6wizn76vc8zc5m2bicw025vj44g0dc1aav806";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ cpio zlib bzip2 file libarchive nspr nss db xz python lua ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt elfutils nss db bzip2 libarchive libbfd ];

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
