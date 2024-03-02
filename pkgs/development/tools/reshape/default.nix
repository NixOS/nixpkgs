{ lib
, rustPlatform
, fetchCrate
, postgresqlTestHook
, postgresql
}:

rustPlatform.buildRustPackage rec {
  pname = "reshape";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wv2gKyXCEH+tnZkUUAisMbuseth3dsFiJujH8VO1ii4=";
  };

  cargoHash = "sha256-VTJ3FNhVLgxo/VVBhk1yF9UUktLXcbrEkYwoyoWFhXA=";

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
