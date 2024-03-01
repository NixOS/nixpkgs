{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages_16
, zlib
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EIZqeqCCnRqJIuhX5Dj9ogZCgFGfA2ukoPwU8AzYupI=";
  };

  cargoHash = "sha256-jLbQ49fxLROEAgokbVAy8yDIRe/MhFJxutRzSEtlnEk=";

  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ llvmPackages_16.llvm ];
  buildInputs = [ zlib ncurses libxml2 ];

  # fails with: couldn't find crate `core` with expected target triple bpfel-unknown-none
  # rust-src and `-Z build-std=core` are required to properly run the tests
  doCheck = false;

  # Work around https://github.com/NixOS/nixpkgs/issues/166205.
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

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
