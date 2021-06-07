{ stdenv, lib, fetchpatch
, pkg-config, autoreconfHook
, fetchurl, cpio, zlib, bzip2, file, elfutils, libbfd, libgcrypt, libarchive, nspr, nss, popt, db, xz, python, lua, llvmPackages
, sqlite, zstd
}:

stdenv.mkDerivation rec {
  pname = "rpm";
  version = "4.16.1.3";

  src = fetchurl {
    url = "http://ftp.rpm.org/releases/rpm-${lib.versions.majorMinor version}.x/rpm-${version}.tar.bz2";
    sha256 = "07g2g0adgjm29wqy94iqhpp5dk0hacfw1yf7kzycrrxnfbwwfgai";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ cpio zlib zstd bzip2 file libarchive libgcrypt nspr nss db xz python lua sqlite ]
                ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

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
  ];

  # Small fixes for ndb on darwin
  # https://github.com/rpm-software-management/rpm/pull/1465
  patches = [
    (fetchpatch {
      name = "darwin-support.patch";
      url = "https://github.com/rpm-software-management/rpm/commit/2d20e371d5e38f4171235e5c64068cad30bda557.patch";
      sha256 = "0p3j5q5a4hl357maf7018k3826jhcpqg6wfrnccrkv30g0ayk171";
    })
  ];

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

  meta = with lib; {
    homepage = "https://www.rpm.org/";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
