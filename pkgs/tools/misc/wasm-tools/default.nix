{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.209.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kdcqR4A0E4Uevt4AK5IgEOKwGYyk/cwe/BNZxbod4NQ=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-6Qnuo8tHSnbGlcgsX+EVCgOcZNU80QcXeqlmz0EVnWE=";
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
