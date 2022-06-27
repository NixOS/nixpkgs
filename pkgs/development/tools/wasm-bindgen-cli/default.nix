{ lib
, rustPlatform
, fetchCrate
, nodejs
, pkg-config
, openssl
, stdenv
, curl
, Security
, runCommand
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.81";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-DUcY22b9+PD6RD53CwcoB+ynGulYTEYjkkonDNeLbGM=";
  };

  cargoSha256 = "sha256-mfVQ6rSzCgwYrN9WwydEpkm6k0E3302Kfs/LaGzRSHE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  checkInputs = [ nodejs ];

  # other tests require it to be ran in the wasm-bindgen monorepo
  cargoTestFlags = [ "--test=interface-types" ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = with licenses; [ asl20 /* or */ mit ];
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ nitsky rizary ];
    mainProgram = "wasm-bindgen";
  };
}
