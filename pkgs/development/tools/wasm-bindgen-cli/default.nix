{ lib
, rustPlatform
, fetchCrate
, nodejs
, pkg-config
, openssl
, stdenv
, curl
, Security
, version ? "0.2.88"
, hash ? "sha256-CpyB2poKIqP4Zfn3Gk1hA9m6EQ/ZiyO91wZViMH7Wsk="
, cargoHash ? "sha256-0D5ABJ3jwsrFIvXSOYgOqJtV5B9JUsHZfJEKl6PO47I="
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
    maintainers = with maintainers; [ nitsky rizary ];
    mainProgram = "wasm-bindgen";
  };
}
