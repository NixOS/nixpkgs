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
  version = "0.5.0";

  src = fetchCrate {
    inherit version;
    pname = "nixci";
    hash = "sha256-XbPXS29zqg+pOs/JRRB2bRPdMTDy/oKLM41UomSZTN0=";
  };

  cargoHash = "sha256-+ed/XsEAwp7bsZOb+bOailpgSFnKvwoHR0QptnGeulk=";

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
