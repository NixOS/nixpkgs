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
  version = "0.2.83";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-+PWxeRL5MkIfJtfN3/DjaDlqRgBgWZMa6dBt1Q+lpd0=";
  };

  cargoSha256 = "sha256-GwLeA6xLt7I+NzRaqjwVpt1pzRex1/snq30DPv4FR+g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  nativeCheckInputs = [ nodejs ];

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
