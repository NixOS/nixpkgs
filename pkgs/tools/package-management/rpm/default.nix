{ stdenv
, lib
, audit
, autoreconfHook
, bzip2
, cmake
, cpio
, db
, dbus
, elfutils
, fetchurl
, file
, gettext
, libarchive
, libbfd
, libcap
, libgcrypt
, libselinux
, llvmPackages
, lua
, nspr
, nss
, pandoc
, pkg-config
, popt
, python
, sqlite
, xz
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: with finalAttrs; {
  pname = "rpm";
  version = "4.19.0";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/releases/rpm-${lib.versions.majorMinor version}.x/rpm-${version}.tar.bz2";
    hash = "sha256-swkW3BSMvqsHd5fp/DZXApMeOpp+rPcK3YQVO1SbP3c=";
  };

  outputs = [ "out" "dev" "man" ];
  separateDebugInfo = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    pandoc
  ];

  buildInputs = [
    audit
    bzip2
    cpio
    db
    dbus
    file
    libarchive
    libgcrypt
    libselinux
    lua
    nspr
    nss
    python
    sqlite
    xz
    zlib
    zstd
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ] ++ lib.optionals stdenv.isLinux [
    libcap
  ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [ popt nss db bzip2 libarchive libbfd ]
    ++ lib.optional stdenv.isLinux elfutils;

  nativeCheckInputs = [
    autoconf
  ];

  env.NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  cmakeFlags = [
    "-DWITH_INTERNAL_OPENPGP=ON"  # TODO: disable and provide `rpm-sequoia` to buildInputs
    "-DENABLE_PYTHON=OFF"  # TODO: re-enable
    "-DENABLE_PLUGINS=OFF"  # TODO: re-enable
    "-DWITH_CAP=${if stdenv.isLinux then "ON" else "OFF"}"
    "-DENABLE_TESTSUITE=${if doCheck then "ON" else "OFF"}"
  ];

  preFixup = ''
    # Avoid helper scripts pointing to absolute paths
    for tool in check-rpaths check-rpaths-worker find-provides find-requires; do
      sed -i $out/lib/rpm/$tool -e "s#/usr/lib/rpm/#$out/lib/rpm/#"
    done
  '';

  enableParallelBuilding = true;
  doCheck = false;  # TODO: remove

  meta = with lib; {
    homepage = "https://www.rpm.org/";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    description = "The RPM Package Manager";
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux;
    # Support for darwin was removed in https://github.com/NixOS/nixpkgs/pull/196350.
    # This can be re-enables for apple_sdk.version >= 13.0.
    badPlatforms = platforms.darwin;
  };
})
