{ lib
, rustPlatform
, fetchCrate
, postgresqlTestHook
, postgresql
}:

rustPlatform.buildRustPackage rec {
  pname = "reshape";
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pTEOVDeCE69dn005nj1ULGKjguCtC1uReI/l3WEz4+w=";
  };

  cargoHash = "sha256-KYU5drTVHdWmlE01Fq1TxJZTe87yBpDKIGm4P+RRCGw=";

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
  ];

  dontUseCargoParallelTests = true;

  postgresqlTestSetupPost = ''
    export POSTGRES_CONNECTION_STRING="user=$PGUSER dbname=$PGDATABASE host=$PGHOST"
  '';

  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  meta = with lib; {
    description = "An easy-to-use, zero-downtime schema migration tool for Postgres";
    homepage = "https://github.com/fabianlindfors/reshape";
    changelog = "https://github.com/fabianlindfors/reshape/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}
