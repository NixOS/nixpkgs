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
, version ? "0.2.93"
, hash ? "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0="
, cargoHash ? "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ="
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
