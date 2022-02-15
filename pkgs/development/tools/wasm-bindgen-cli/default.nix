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
  version = "0.2.79";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3kWhhzYmIo/GFieI0i7XVJIZxIaaJHHuDp38k5xcFmI=";
  };

  cargoSha256 = "sha256-xKYdvcrx3a9AKiRU8yJ3JNQp1Q2pEufwo+in82yTV6c=";

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
