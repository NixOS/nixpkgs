{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.216.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HgeiZo/wXLKYwTQv/gcKHNz3p9jfp/8OYSrum3TPI2Q=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-KS/mg3OZHCyb6IKmbED18xPCblYk0euzdqz7fJl0plI=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
}
