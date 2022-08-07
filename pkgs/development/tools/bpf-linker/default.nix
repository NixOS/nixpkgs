{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages_14
, zlib
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jYuBk78aGQLUeNF6d6kjGPuMxEF22XJquHcs23WVGm0=";
  };

  cargoHash = "sha256-X8EVpOxDHwE/wj/gly/wdZ6tsrMrz3kkDe9gEPbk6iw=";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "system-llvm" ];

  nativeBuildInputs = [ llvmPackages_14.llvm ];
  buildInputs = [ zlib ncurses libxml2 ];

  # fails with: couldn't find crate `core` with expected target triple bpfel-unknown-none
  # rust-src and `-Z build-std=core` are required to properly run the tests
  doCheck = false;

  meta = with lib; {
    description = "Simple BPF static linker";
    homepage = "https://github.com/aya-rs/bpf-linker";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ nickcao ];
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
