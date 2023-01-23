{ lib
, rustPlatform
, fetchCrate
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.8.0";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    sha256 = "sha256-od8uL2xvIGFtftob3P0VQ+SPkwQgU68OxS6hk34c4+U=";
  };

  cargoSha256 = "sha256-1ba0FqegYNbRis7Nwl2RONHOxq0iuLah8a1QlWs4HfE=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
