{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.0.37";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-3LswpSnXCRaDeoViEa/EnyB472g4TlLYc705rUmfN9M=";
    fetchSubmodules = true;
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [ "--package" "wasm-tools" ];

  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
  };
}
