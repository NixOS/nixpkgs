{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pgcat";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "postgresml";
    repo = "pgcat";
    rev = "v${version}";
    hash = "sha256-BERxdGgPk8POnhLsyy4lKV4LCoHsJTmv2OhAOz6CKKc=";
  };

  cargoHash = "sha256-GwcqR8pEvz42NEmcuXpcoPdChzRBYsDEnllX62T8ulQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires network access
    "--skip=dns_cache::CachedResolver::lookup_ip"
    "--skip=dns_cache::CachedResolver::new"
    "--skip=dns_cache::CachedResolver"
    "--skip=dns_cache::tests::has_changed"
    "--skip=dns_cache::tests::incorrect_address"
    "--skip=dns_cache::tests::lookup_ip"
    "--skip=dns_cache::tests::new"
    "--skip=dns_cache::tests::thread"
    "--skip=dns_cache::tests::unknown_host"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/pgcat --version | grep "pgcat ${version}"
  '';

  meta = with lib; {
    homepage = "https://github.com/postgresml/pgcat";
    description = "PostgreSQL pooler with sharding, load balancing and failover support";
    license = with licenses; [mit];
    platforms = platforms.unix;
    maintainers = with maintainers; [cathalmullan];
    mainProgram = "pgcat";
  };
}
