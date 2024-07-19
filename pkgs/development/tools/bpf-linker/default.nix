{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages_18
, zlib
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HMLbNAB6Ze2x8OeAwVXMMn5P9GYK9hCa61Ic5yqblUA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "compiletest_rs-0.10.2" = "sha256-n1OxKal1B+WNshfMgtiA5Th+FQyDalOdB4PAo6mUzwQ=";
    };
  };

  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ llvmPackages_18.llvm ];
  buildInputs = [ zlib ncurses libxml2 ];

  # fails with: couldn't find crate `core` with expected target triple bpfel-unknown-none
  # rust-src and `-Z build-std=core` are required to properly run the tests
  doCheck = false;

  meta = with lib; {
    description = "Simple BPF static linker";
    mainProgram = "bpf-linker";
    homepage = "https://github.com/aya-rs/bpf-linker";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ nickcao ];
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
