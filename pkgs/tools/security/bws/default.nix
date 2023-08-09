{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, openssl
, stdenv
, darwin
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "bws";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "bws-v${version}";
    hash = "sha256-o+tmO9E881futhA/fN6+EX2yEBKnKUmKk/KilIt5vYY=";
  };

  cargoHash = "sha256-nmsAfXNn1nqmqHzGD7jl2JNrif/nJycCJZWZYjv7G4c=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  buildAndTestSubdir = "crates/bws";

  meta = {
    changelog = "https://github.com/bitwarden/sdk/blob/${src.rev}/CHANGELOG.md";
    description = "Bitwarden Secrets Manager CLI";
    homepage = "https://github.com/bitwarden/sdk";
    license = lib.licenses.unfree; # BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT
    mainProgram = "bws";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
