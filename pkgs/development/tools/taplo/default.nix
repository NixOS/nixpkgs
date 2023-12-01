{ lib
, rustPlatform
, fetchCrate
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.8.1";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    sha256 = "sha256-evNW6OA7rArj0TvOaQgktcQy0tWnel3ZL+ic78e6lOk=";
  };

  cargoSha256 = "sha256-jeLjoqEieR96mUZQmQtv7P78lmOaF18ruVhZLi/TieQ=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
