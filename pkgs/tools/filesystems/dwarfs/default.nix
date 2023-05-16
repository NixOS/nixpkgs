{ lib
, fetchFromGitHub
, stdenv
, substituteAll

, bison
, boost
, cmake
, double-conversion
<<<<<<< HEAD
, fmt
, fuse3
=======
, fmt_8
, fuse3
, gflags
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, utf8cpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zstd
}:

stdenv.mkDerivation rec {
  pname = "dwarfs";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-DcPRrATI2cpLZWAL+sSCoXvJ1R0O3yHqhlJW1aEpDpA=";
  };

  patches = [
    (with lib.versions; substituteAll {
      src = ./version_info.patch;

      versionFull = version; # displayed as version number (with v prepended)
=======
    sha256 = "sha256-fA/3AooDndqYiK215cu/zTqCqeccHnwIX2CfJ9sC+Fc=";
  };

  patches = with lib.versions; [
    (substituteAll {
      src = ./version_info.patch;

      gitRev = "v${version}";
      gitDesc = "v${version}";
      gitBranch = "v${version}";
      gitId = "v${version}"; # displayed as version number

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      versionMajor = major version;
      versionMinor = minor version;
      versionPatch = patch version;
    })
  ];

  cmakeFlags = [
    "-DPREFER_SYSTEM_ZSTD=ON"
    "-DPREFER_SYSTEM_XXHASH=ON"
    "-DPREFER_SYSTEM_GTEST=ON"
<<<<<<< HEAD
    "-DPREFER_SYSTEM_LIBFMT=ON"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # may be added under an option in the future
    # "-DWITH_LEGACY_FUSE=ON"
    "-DWITH_TESTS=ON"
<<<<<<< HEAD
=======

    # temporary hack until folly builds work on aarch64,
    # see https://github.com/facebook/folly/issues/1880
    "-DCMAKE_LIBRARY_ARCHITECTURE=${if stdenv.isx86_64 then "x86_64" else "dummy"}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    fmt
=======
    fmt_8
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fuse3
    jemalloc
    libarchive
    lz4
    xxHash
<<<<<<< HEAD
    utf8cpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  # these fail inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER = "-dwarfs/tools_test.end_to_end/*:dwarfs/tools_test.mutating_ops/*";
=======
  # this fails inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER = "-tools.everything";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ keksbg ];
    platforms = platforms.linux;
  };
}
