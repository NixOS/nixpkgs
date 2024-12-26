{
  stdenv,
  lib,
  pkg-config,
  autoreconfHook,
  pandoc,
  fetchpatch2,
  fetchurl,
  cpio,
  zlib,
  bzip2,
  file,
  elfutils,
  libbfd,
  libgcrypt,
  libarchive,
  nspr,
  nss,
  popt,
  db,
  xz,
  python,
  lua,
  llvmPackages,
  sqlite,
  zstd,
  libcap,
  apple-sdk_13,
  darwinMinVersionHook,
}:

stdenv.mkDerivation rec {
  pname = "rpm";
  version = "4.18.1";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/releases/rpm-${lib.versions.majorMinor version}.x/rpm-${version}.tar.bz2";
    hash = "sha256-N/O0LAlmlB4q0/EP3jY5gkplkdBxl7qP0IacoHeeH1Y=";
  };

  patches = [
    # Resolves `error: expected expression` on clang
    # See: https://github.com/rpm-software-management/rpm/issues/2435.
    (fetchpatch2 {
      url = "https://github.com/rpm-software-management/rpm/commit/b960c0b43a080287a7c13533eeb2d9f288db1414.diff?full_index=1";
      hash = "sha256-0f7YOL2xR07xgAEN32oRbOjPsAsVmKFVtTLXUOeFAa8=";
    })
    # Fix missing includes required to build on Darwin.
    # See: https://github.com/rpm-software-management/rpm/pull/2571.
    (fetchpatch2 {
      url = "https://github.com/rpm-software-management/rpm/commit/f07875392a09228b1a25c1763a50bbbd0f6798c2.diff?full_index=1";
      hash = "sha256-DLpzMApRCgI9zqheglFtqL8E1vq9X/aQa0HMnIAQgk8=";
    })
    (fetchpatch2 {
      url = "https://github.com/rpm-software-management/rpm/commit/b2e67642fd8cb64d8cb1cca9e759396c1c10807d.diff?full_index=1";
      hash = "sha256-q3fIBfiUJVmw6Vi2/Bo/zX6/cqTM7aFnskKfMVK3DlU=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];
  separateDebugInfo = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
  ];
  buildInputs =
    [
      cpio
      zlib
      zstd
      bzip2
      file
      libarchive
      libgcrypt
      nspr
      nss
      db
      xz
      python
      lua
      sqlite
    ]
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
    ++ lib.optional stdenv.hostPlatform.isLinux libcap
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_13
      (darwinMinVersionHook "13.0")
    ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [
    popt
    nss
    db
    bzip2
    libarchive
    libbfd
  ] ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  env.NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

  configureFlags = [
    "--with-external-db"
    "--with-lua"
    "--enable-python"
    "--enable-ndb"
    "--enable-sqlite"
    "--enable-zstd"
    "--localstatedir=/var"
    "--sharedstatedir=/com"
  ] ++ lib.optional stdenv.hostPlatform.isLinux "--with-cap";

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
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    description = "RPM Package Manager";
    maintainers = with maintainers; [ copumpkin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
