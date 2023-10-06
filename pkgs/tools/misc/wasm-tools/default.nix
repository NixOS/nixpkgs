{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.0.43";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-z2R4WpdRqe1KCNY8hotE/Pp+JMvoAF1+DqER8GA0ceA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-BtXaDqpjri8wRiq7QlipACyEEK/RKgwx7Y6QPX3FeE0=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
  };
}
