{ lib, stdenv
, rustPlatform
, fetchCrate
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, Security
, SystemConfiguration
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "nixci";
  version = "0.4.0";

  src = fetchCrate {
    inherit version;
    pname = "nixci";
    hash = "sha256-JC1LUny8UKflANlcx6Hcgx39CRry+ossnp/RQK36oaI=";
  };

  cargoHash = "sha256-pYPzM7QlQ2EXwrvuXMa1qs0m7cmumh1iPesgJZ0H2kg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    IOKit
    Security
    SystemConfiguration
  ];

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
    maintainers = with maintainers; [ srid shivaraj-bh ];
    mainProgram = "nixci";
  };
}
