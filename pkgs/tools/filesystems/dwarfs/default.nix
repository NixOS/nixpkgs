{ lib
, fetchFromGitHub
, stdenv
, substituteAll

, bison
, boost
, cmake
, double-conversion
, fmt
, fuse3
, glog
, gtest
, jemalloc
, libarchive
, libevent
, libunwind
, lz4
, openssl
, pkg-config
, ronn
, xxHash
, utf8cpp
, zstd
}:

stdenv.mkDerivation rec {
  pname = "dwarfs";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-wclUyATUZmF7EEkrK9nWASmfiB+MBrvEzc73ngOrhZ0=";
  };

  patches = [
    (with lib.versions; substituteAll {
      src = ./version_info.patch;

      versionFull = version; # displayed as version number (with v prepended)
      versionMajor = major version;
      versionMinor = minor version;
      versionPatch = patch version;
    })
  ];

  cmakeFlags = [
    "-DPREFER_SYSTEM_ZSTD=ON"
    "-DPREFER_SYSTEM_XXHASH=ON"
    "-DPREFER_SYSTEM_GTEST=ON"
    "-DPREFER_SYSTEM_LIBFMT=ON"

    # may be added under an option in the future
    # "-DWITH_LEGACY_FUSE=ON"
    "-DWITH_TESTS=ON"
  ];

  nativeBuildInputs = [
    bison
    cmake
    pkg-config
    ronn
  ];

  buildInputs = [
    # dwarfs
    boost
    fmt
    fuse3
    jemalloc
    libarchive
    lz4
    xxHash
    utf8cpp
    zstd

    # folly
    double-conversion
    glog
    libevent
    libunwind
    openssl
  ];

  doCheck = true;
  nativeCheckInputs = [ gtest ];
  # these fail inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER = "-dwarfs/tools_test.end_to_end/*:dwarfs/tools_test.mutating_ops/*";

  meta = with lib; {
    description = "A fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ keksbg ];
    platforms = platforms.linux;
  };
}
