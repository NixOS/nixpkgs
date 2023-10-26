{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.0.48";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-7LAmU5Ay8Zf8wdKAj7am6cGmWtD5L+lUyxeiv1yv/A4=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-QWWz5c+D2UH+CWGJTaTEuAqHVIW4hu1cM7LWKO7K98Q=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
  };
}
