{ boost
, cargo
, cmake
<<<<<<< HEAD
=======
, config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, CoreServices
, cpptoml
, double-conversion
, edencommon
, ensureNewerSourcesForZipFilesHook
, fb303
, fbthrift
, fetchFromGitHub
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
<<<<<<< HEAD
, pcre2
, pkg-config
=======
, pcre
, pkg-config
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "2023.08.14.00";
=======
  version = "2023.01.30.00";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-41bBPFlLYFHySyX4/GUllT1pNywSRcH7x/pnb5iN/1o=";
=======
    sha256 = "sha256-ZtCUlxx3YgfwKa9J8o9GkdkHquJbh+EytLiGNRlABls=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pcre2
    openssl
=======
    pcre
    openssl
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  postPatch = ''
    patchShebangs .
    cp ${./Cargo.lock} ${cargoRoot}/Cargo.lock
  '';

  meta = with lib; {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with maintainers; [ cstrahan kylesferrazza ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
