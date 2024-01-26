{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

let
  pname = "cargo-pgrx";
  version = "0.11.3";
in
rustPlatform.buildRustPackage rec {
  inherit version pname;

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-UHIfwOdXoJvR4Svha6ud0FxahP1wPwUtviUwUnTmLXU=";
  };

  cargoHash = "sha256-j4HnD8Zt9uhlV5N7ldIy9564o9qFEqs5KfXHmnQ1WEw=";

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
