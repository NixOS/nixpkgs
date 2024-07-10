{ lib
, rustPlatform
, fetchCrate
, nix-update-script
, nodejs
, pkg-config
, openssl
, stdenv
, curl
, Security
, version ? "0.2.92"
, hash ? "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0="
, cargoHash ? "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0="
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  inherit version hash cargoHash;

  src = fetchCrate {
    inherit pname version hash;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  nativeCheckInputs = [ nodejs ];

  # tests require it to be ran in the wasm-bindgen monorepo
  doCheck = false;

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = with licenses; [ asl20 /* or */ mit ];
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ rizary ];
    mainProgram = "wasm-bindgen";
  };

  passthru.updateScript = nix-update-script { };
}
