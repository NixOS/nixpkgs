{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.0.58";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-9IvfQqX65VvjvgyVC0Pn/uJa9EaFh2Y/ciDS+/0RvE4=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-JtIpBHX2ShGb/gaNefkGYzH4ltz2U7v8LwD/IBrfTgw=";
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
