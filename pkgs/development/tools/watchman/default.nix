{ boost
, cargo
, cmake
, CoreServices
, cpptoml
, double-conversion
, edencommon
, ensureNewerSourcesForZipFilesHook
, fb303
, fbthrift
, fetchFromGitHub
, fetchpatch
, fizz
, fmt_8
, folly
, glog
, gtest
, lib
, libevent
, libiconv
, libsodium
, libunwind
, lz4
, openssl
, pcre2
, pkg-config
, rustPlatform
, rustc
, stateDir ? "/tmp"
, stdenv
, wangle
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "watchman";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    hash = "sha256-cD8mIYCc+8Z2p3rwKVRFcW9sOBbpb5KHU5VpbXHMpeg=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_EDEN_SUPPORT=NO" # requires sapling (formerly known as eden), which is not packaged in nixpkgs
    "-DWATCHMAN_STATE_DIR=${stateDir}"
    "-DWATCHMAN_VERSION_OVERRIDE=${version}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ensureNewerSourcesForZipFilesHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    pcre2
    openssl
    gtest
    glog
    boost
    libevent
    fmt_8
    libsodium
    zlib
    folly
    fizz
    wangle
    fbthrift
    fb303
    cpptoml
    edencommon
    libunwind
    double-conversion
    lz4
    zstd
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoRoot = "watchman/cli";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  patches = [
    # fix build with rustc >=1.79
    (fetchpatch {
      url = "https://github.com/facebook/watchman/commit/c3536143cab534cdd9696eb3e2d03c4ac1e2f883.patch";
      hash = "sha256-lpGr5H28gfVXkWNdfDo4SCbF/p5jB4SNlHj6km/rfw4=";
    })
  ];

  postPatch = ''
    patchShebangs .
    cp ${./Cargo.lock} ${cargoRoot}/Cargo.lock
  '';

  meta = with lib; {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with maintainers; [ kylesferrazza ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
