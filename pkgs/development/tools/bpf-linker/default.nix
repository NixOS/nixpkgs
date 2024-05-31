{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages_15
, zlib
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LEZ2to1bzJ/H/XYytuh/7NT7+04aI8chpKIFxxVzM+4=";
  };

  cargoHash = "sha256-s8cW7lXtvgemuQueTtAywewnDVJ/WDcz8SBqsC/tO80=";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "system-llvm" ];

  nativeBuildInputs = [ llvmPackages_15.llvm ];
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
