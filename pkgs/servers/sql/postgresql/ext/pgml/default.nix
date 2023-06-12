{ lib
, buildPgrxExtension
, fetchFromGitHub
, nix-update-script
, python3
, pkg-config
, openssl
, cmake
, postgresql
}:
let
  pname = "postgresml";
  version = "2.5.1";
  src = fetchFromGitHub {
    owner = "postgresml";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BkBPCYmylU5MgsevARHvDYSBKMbpZ8Y1w2oHp/eUt9o=";
    fetchSubmodules = true;
  };
in
buildPgrxExtension {
  inherit pname version postgresql;

  src = "${src}/pgml-extension";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lightgbm-0.2.3" = "sha256-7Lld+p2Z2ejjmwFBcJIjw1Tkr3fjDV3aSntRhZPk9rw=";
      "xgboost-0.2.0" = "sha256-ajQPgfwyBJEOfHT5850WXOSmam9YObqOLCfqEaNMAro=";
    };
  };

  nativeBuildInputs = [
    python3
    pkg-config
    cmake
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Machine learning extension for postgresql";
    longDescription = ''
      PostgresML is an AI application database.
      Download open source models from Huggingface, or train your own,
      to create and index LLM embeddings, generate text, or make online predictions using only SQL
    '';
    homepage = "https://postgresml.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; linux;
  };
}
