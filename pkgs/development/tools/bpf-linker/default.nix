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
  version = "0.9.12-unstable-2024-07-31";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "7585ff7c0709bae13f2ad25f421450d493b02c1a";
    hash = "sha256-HvjS+74ZjyhF3h2IaKq4T+aGB5/XJRR3TxLSxp0rEYk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "compiletest_rs-0.10.2" = "sha256-JTfVfMW0bCbFjQxeAFu3Aex9QmGnx0wp6weGrNlQieA=";
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
