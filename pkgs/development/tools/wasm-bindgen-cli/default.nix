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
  version = "0.2.78";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5s+HidnVfDV0AXA+/YcXNGVjv/E9JeK0Ttng4mCVX8M=";
  };

  cargoSha256 = "sha256-CbtjUFwowP/QqyAMCzmUiSib4EpRhQAmO4ekX00xYGE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  checkInputs = [ nodejs ];

  # other tests require it to be ran in the wasm-bindgen monorepo
  cargoTestFlags = [ "--test=interface-types" ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = with licenses; [ asl20 /* or */ mit ];
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 nitsky rizary ];
    mainProgram = "wasm-bindgen";
  };
}
