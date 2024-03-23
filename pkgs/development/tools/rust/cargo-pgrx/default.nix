{ lib
, darwin
, fetchCrate
, openssl
, pkg-config
, rustPlatform
, stdenv
}:

let
  generic =
    { version
    , hash
    , cargoHash
    }:
    rustPlatform.buildRustPackage rec {
      pname = "cargo-pgrx";

      inherit version;

      src = fetchCrate {
        inherit version pname hash;
      };

      inherit cargoHash;

      nativeBuildInputs = lib.optionals stdenv.isLinux [
        pkg-config
      ];

      buildInputs = lib.optionals stdenv.isLinux [
        openssl
      ] ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.Security
      ];

      preCheck = ''
        export PGRX_HOME=$(mktemp -d)
      '';

      checkFlags = [
        # requires pgrx to be properly initialized with cargo pgrx init
        "--skip=command::schema::tests::test_parse_managed_postmasters"
      ];

      meta = with lib; {
        description = "Build Postgres Extensions with Rust";
        homepage = "https://github.com/pgcentralfoundation/pgrx";
        changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${version}";
        license = licenses.mit;
        maintainers = with maintainers; [ happysalada ];
        mainProgram = "cargo-pgrx";
      };
    };
in
{
  cargo-pgrx_0_10_2 = generic {
    version = "0.10.2";
    hash = "sha256-FqjfbJmSy5UCpPPPk4bkEyvQCnaH9zYtkI7txgIn+ls=";
    cargoHash = "sha256-syZ3cQq8qDHBLvqmNDGoxeK6zXHJ47Jwkw3uhaXNCzI=";
  };

  cargo-pgrx_0_11_2 = generic {
    version = "0.11.2";
    hash = "sha256-8NlpMDFaltTIA8G4JioYm8LaPJ2RGKH5o6sd6lBHmmM=";
    cargoHash = "sha256-qTb3JV3u42EilaK2jP9oa5D09mkuHyRbGGRs9Rg4TzI=";
  };

  cargo-pgrx_0_11_3 = generic {
    version = "0.11.3";
    hash = "sha256-UHIfwOdXoJvR4Svha6ud0FxahP1wPwUtviUwUnTmLXU=";
    cargoHash = "sha256-j4HnD8Zt9uhlV5N7ldIy9564o9qFEqs5KfXHmnQ1WEw=";
  };
}
