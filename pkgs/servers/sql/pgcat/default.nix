{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  nix-update-script,
  testers,
  pgcat,
}:

rustPlatform.buildRustPackage rec {
  pname = "pgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "postgresml";
    repo = "pgcat";
    rev = "v${version}";
    hash = "sha256-DHXUhAAOmPSt4aVp93I1y69of+MEboXJBZH50mzQTm8=";
  };

  cargoHash = "sha256-QqwUEbWKSUuxzYjWpVpQuKZDiNib1gM2eZJ4y7XIzXY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires network access
    "--skip=dns_cache"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = pgcat; };
  };

  meta = with lib; {
    homepage = "https://github.com/postgresml/pgcat";
    description = "PostgreSQL pooler with sharding, load balancing and failover support";
    changelog = "https://github.com/postgresml/pgcat/releases";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ cathalmullan ];
    mainProgram = "pgcat";
  };
}
