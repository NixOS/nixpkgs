{
  lib,
  rustPlatform,
  fetchCrate,
  darwin,
  postgresqlTestHook,
  postgresql,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "reshape";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wv2gKyXCEH+tnZkUUAisMbuseth3dsFiJujH8VO1ii4=";
  };

  cargoHash = "sha256-VTJ3FNhVLgxo/VVBhk1yF9UUktLXcbrEkYwoyoWFhXA=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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
    description = "Easy-to-use, zero-downtime schema migration tool for Postgres";
    mainProgram = "reshape";
    homepage = "https://github.com/fabianlindfors/reshape";
    changelog = "https://github.com/fabianlindfors/reshape/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}
