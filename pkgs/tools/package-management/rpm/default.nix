{
  stdenv,
  lib,
  pkg-config,
  cmake,
  fetchurl,
  zlib,
  bzip2,
  file,
  elfutils,
  libarchive,
  readline,
  audit,
  popt,
  xz,
  python3,
  lua,
  llvmPackages,
  sqlite,
  zstd,
  libcap,
  apple-sdk_13,
  darwinMinVersionHook,
  openssl,
  #, libselinux
  rpm-sequoia,
  gettext,
  systemd,
  bubblewrap,
  autoconf,
  gnupg,
}:

stdenv.mkDerivation rec {
  pname = "rpm";
  version = "4.20.0";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/releases/rpm-${lib.versions.majorMinor version}.x/rpm-${version}.tar.bz2";
    hash = "sha256-Vv92OM/5i1bUp1A/9ZvHnygabd/82g0jjAgr7ftfvns=";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python3.sitePackages}#' python/CMakeLists.txt
    sed -i 's#PATHS ENV MYPATH#PATHS ENV PATH#' CMakeLists.txt
  '';

  outputs =
    [
      "out"
      "man"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "dev"
    ];
  separateDebugInfo = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
    python3
    gettext
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ];
  buildInputs =
    [
      bzip2
      zlib
      zstd
      file
      libarchive
      xz
      lua
      sqlite
      openssl
      readline
      rpm-sequoia
      gnupg
    ]
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
      audit
      systemd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_13
      (darwinMinVersionHook "13.0")
    ];

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./sighandler_t-macos.patch
  ];

  cmakeFlags =
    [
      "-DWITH_DBUS=OFF"
      # libselinux is missing propagatedBuildInputs
      "-DWITH_SELINUX=OFF"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "-DMKTREE_BACKEND=rootfs"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      # Test suite rely on either podman or bubblewrap
      "-DENABLE_TESTSUITE=OFF"

      "-DWITH_CAP=OFF"
      "-DWITH_AUDIT=OFF"
      "-DWITH_ACL=OFF"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DWITH_LIBELF=OFF"
      "-DWITH_LIBDW=OFF"
    ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [
    popt
  ] ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

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
