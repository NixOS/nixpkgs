{ lib, stdenv
, rustPlatform
, fetchCrate
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nixci";
  version = "0.2.0";

  src = fetchCrate {
    inherit version;
    pname = "nixci";
    hash = "sha256-Q3V/JL64xkIj0X0NSMRTjRAP3PJC9ouj3CmEscVWdns=";
  };

  cargoHash = "sha256-tjk91AaPsMLfXYB2o1HTTxb6Qr3l8BABPStrKEGvbtM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # The rust program expects an environment (at build time) that points to the
  # devour-flake flake.
  env.DEVOUR_FLAKE = fetchFromGitHub {
    owner = "srid";
    repo = "devour-flake";
    rev = "v3";
    hash = "sha256-O51F4YFOzlaQAc9b6xjkAqpvrvCtw/Os2M7TU0y4SKQ=";
  };

  meta = with lib; {
    description = "Define and build CI for Nix projects anywhere";
    homepage = "https://github.com/srid/nixci";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ srid ];
    mainProgram = "nixci";
  };
}
