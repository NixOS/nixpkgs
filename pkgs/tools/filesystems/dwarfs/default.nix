{ lib
, fetchFromGitHub
, stdenv
, substituteAll

, bison
, boost
, cmake
, double-conversion
, fmt_8
, fuse3
, gflags
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
, zstd
}:

stdenv.mkDerivation rec {
  pname = "dwarfs";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-fA/3AooDndqYiK215cu/zTqCqeccHnwIX2CfJ9sC+Fc=";
  };

  patches = with lib.versions; [
    (substituteAll {
      src = ./version_info.patch;

      gitRev = "v${version}";
      gitDesc = "v${version}";
      gitBranch = "v${version}";
      gitId = "v${version}"; # displayed as version number

      versionMajor = major version;
      versionMinor = minor version;
      versionPatch = patch version;
    })
  ];

  cmakeFlags = [
    "-DPREFER_SYSTEM_ZSTD=ON"
    "-DPREFER_SYSTEM_XXHASH=ON"
    "-DPREFER_SYSTEM_GTEST=ON"

    # may be added under an option in the future
    # "-DWITH_LEGACY_FUSE=ON"
    "-DWITH_TESTS=ON"

    # temporary hack until folly builds work on aarch64,
    # see https://github.com/facebook/folly/issues/1880
    "-DCMAKE_LIBRARY_ARCHITECTURE=${if stdenv.isx86_64 then "x86_64" else "dummy"}"
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
    fmt_8
    fuse3
    jemalloc
    libarchive
    lz4
    xxHash
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
  # this fails inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER = "-tools.everything";

  meta = with lib; {
    description = "A fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ keksbg ];
    platforms = platforms.linux;
  };
}
