{ lib
, rustPlatform
, fetchCrate
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.7.2";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    sha256 = "sha256-AiX6ruiyyWt33G49dD9ozFXq+3efEMzJoeWVfP5UGGo=";
  };

  cargoSha256 = "sha256-Uvc/1CE8eaYfelJ3U8zxF2HVx9P7G1ZVQB5tCvQDTac=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
