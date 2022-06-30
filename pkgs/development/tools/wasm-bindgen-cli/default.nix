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
  version = "0.2.80";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-f3XRVuK892TE6xP7eq3aKpl9d3fnOFxLh+/K59iWPAg=";
  };

  cargoSha256 = "sha256-WJ5hPw2mzZB+GMoqo3orhl4fCFYKWXOWqaFj1EMrb2Q=";

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
