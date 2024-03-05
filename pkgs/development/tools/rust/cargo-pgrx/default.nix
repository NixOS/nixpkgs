{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

let
  pname = "cargo-pgrx";
  version = "0.11.2";
in
rustPlatform.buildRustPackage rec {
  inherit version pname;

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-8NlpMDFaltTIA8G4JioYm8LaPJ2RGKH5o6sd6lBHmmM=";
  };

  cargoHash = "sha256-qTb3JV3u42EilaK2jP9oa5D09mkuHyRbGGRs9Rg4TzI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  preCheck = ''
    export PGRX_HOME=$(mktemp -d)
  '';

  checkFlags = [
    # requires pgrx to be properly initialized with cargo pgrx init
    "--skip=command::schema::tests::test_parse_managed_postmasters"
  ];

  meta = with lib; {
    description = "Build Postgres Extensions with Rust!";
    homepage = "https://github.com/tcdi/pgrx";
    changelog = "https://github.com/tcdi/pgrx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
