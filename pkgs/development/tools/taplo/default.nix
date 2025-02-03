{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.9.0";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    hash = "sha256-vvb00a6rppx9kKx+pzObT/hW/IsG6RyYFEDp9M5gvqc=";
  };

  cargoHash = "sha256-oT7U9htu7J22MqLZb+YXohlB1CVGxHGQvHJu18PeLf8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
