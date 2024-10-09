{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.217.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nxfYoR0ba0As00WbahSVFNItSlleMmITqs8eJabjD/U=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-mBSRJYSE3HmeWhnW4nFF8uFnUJaZ6wdqsq+GnL6SZWc=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ] ++
    # Due to https://github.com/bytecodealliance/wasm-tools/issues/1820
    [ "--" "--test-threads=1" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
}
