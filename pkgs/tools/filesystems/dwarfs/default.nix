{
  lib,
  fetchFromGitHub,
  stdenv,
  substituteAll,
  bison,
  boost,
  cmake,
  double-conversion,
  fmt,
  fuse3,
  flac,
  glog,
  gtest,
  howard-hinnant-date,
  jemalloc,
  libarchive,
  libevent,
  libunwind,
  lz4,
  openssl,
  pkg-config,
  python3,
  range-v3,
  ronn,
  xxHash,
  utf8cpp,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dwarfs";
  version = "0.9.10";
  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-uyYNs+fDV5BfQwfX9Wi3BwiKjSDQHAKRJ1+UvS/fHoE=";
  };

  cmakeFlags = [
    "-DNIXPKGS_DWARFS_VERSION_OVERRIDE=v${finalAttrs.version}" # see https://github.com/mhx/dwarfs/issues/155

    # Needs to be set so `dwarfs` does not try to download `gtest`; it is not
    # a submodule, see: https://github.com/mhx/dwarfs/issues/188#issuecomment-1907657083
    "-DPREFER_SYSTEM_GTEST=ON"

    # These should no longer be necessary with a version > 0.9.10:
    # * https://github.com/mhx/dwarfs/commit/593b22a8a90eb66c0898ae06f097f32f4bf3dfd4
    # * https://github.com/mhx/dwarfs/commit/6e9608b2b01be13e41e6b728aae537c14c00ad82
    # * https://github.com/mhx/dwarfs/commit/ce4bee1ad63c666da57d2cdae9fd65214d8dab7f
    "-DPREFER_SYSTEM_LIBFMT=ON"
    "-DPREFER_SYSTEM_ZSTD=ON"
    "-DPREFER_SYSTEM_XXHASH=ON"

    # may be added under an option in the future
    # "-DWITH_LEGACY_FUSE=ON"

    "-DWITH_TESTS=ON"
  ];

  nativeBuildInputs = [
    bison
    cmake
    howard-hinnant-date # uses only the header-only parts
    pkg-config
    range-v3 # header-only library
    ronn
    (python3.withPackages (ps: [ ps.mistletoe ])) # for man pages
  ];

  buildInputs = [
    # dwarfs
    boost
    flac # optional; allows automatic audio compression
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
  nativeCheckInputs = [
    # https://github.com/mhx/dwarfs/issues/188#issuecomment-1907574427
    # `dwarfs` sets C++20 as the minimum, see
    #     https://github.com/mhx/dwarfs/blob/2cb5542a5d4274225c5933370adcf00035f6c974/CMakeLists.txt#L129
    # Thus the `gtest` headers, when included,
    # refer to symbols that only exist in `.so` files compiled with that version.
    (gtest.override { cxx_standard = "20"; })
  ];
  # these fail inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER =
    let
      disabledTests = [
        "dwarfs/tools_test.end_to_end/*"
        "dwarfs/tools_test.mutating_and_error_ops/*"
        "dwarfs/tools_test.categorize/*"
      ];
    in
      "-${lib.concatStringsSep ":" disabledTests}";

  meta = {
    description = "Fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    changelog = "https://github.com/mhx/dwarfs/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    platforms = lib.platforms.linux;
  };
})
