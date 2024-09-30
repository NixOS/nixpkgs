{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  cmake,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "refs/tags/v${version}";
    hash = "sha256-NEujk4ZPQ2xHWBCVjBCD7H6f58P4KrwCNoDHKa0d5JE=";
  };

  cargoHash = "sha256-pFKGQcWW1/GaIIWMyWBzts4w1hMu27hTG/uUMjkfDMo=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security ++ [
    zstd
  ];

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = with lib; {
    description = "Utility that builds rust-generated WebAssembly package";
    mainProgram = "wasm-pack";
    homepage = "https://github.com/rustwasm/wasm-pack";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.dhkl ];
  };
}
