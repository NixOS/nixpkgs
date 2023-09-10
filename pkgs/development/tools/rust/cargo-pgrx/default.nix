{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

let
  pname = "cargo-pgrx";
  version = "0.10.0";
in
rustPlatform.buildRustPackage rec {
  inherit version pname;

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-iqKcYp0dsay3/OE+N6KLjGEnloaImyS5xNaVciOYERc=";
  };

  cargoHash = "sha256-IWqHt6RL5ICBarmVx7QNjt3JrS0JYi/odEjPkLYMsPI=";

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
