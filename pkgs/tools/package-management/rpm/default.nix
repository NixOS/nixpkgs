{ stdenv, lib
, pkg-config, autoreconfHook
, fetchurl, cpio, zlib, bzip2, file, elfutils, libbfd, libgcrypt, libarchive, nspr, nss, popt, db, xz, python3, lua, llvmPackages
, sqlite, zstd, libcap
}:

stdenv.mkDerivation rec {
  pname = "rpm";
  version = "4.18.0";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/releases/rpm-${lib.versions.majorMinor version}.x/rpm-${version}.tar.bz2";
    hash = "sha256-KhcVLXGHqzDt8sL7WGRjvfY4jee1g3SAlVZZ5ekFRVQ=";
  };

  outputs = [ "out" "dev" "man" ];
  separateDebugInfo = true;

  nativeBuildInputs = [ autoreconfHook pkg-config python3 ];
  buildInputs = [ cpio zlib zstd bzip2 file libarchive libgcrypt nspr nss db xz python3 lua sqlite ]
                ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
                ++ lib.optional stdenv.isLinux libcap;

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt nss db bzip2 libarchive libbfd ]
    ++ lib.optional stdenv.isLinux elfutils;

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  configureFlags = [
    "--with-external-db"
    "--with-lua"
    "--enable-python"
    "--enable-ndb"
    "--enable-sqlite"
    "--enable-zstd"
    "--localstatedir=/var"
    "--sharedstatedir=/com"
  ] ++ lib.optional stdenv.isLinux "--with-cap";

  postPatch = ''
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

    # Avoid helper scripts pointing to absolute paths
    for tool in find-provides find-requires; do
      sed -i $out/lib/rpm/$tool -e "s#/usr/lib/rpm/#$out/lib/rpm/#"
    done

    # symlinks produced by build are incorrect
    ln -sf $out/bin/{rpm,rpmquery}
    ln -sf $out/bin/{rpm,rpmverify}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.rpm.org/";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux;
  };
}
