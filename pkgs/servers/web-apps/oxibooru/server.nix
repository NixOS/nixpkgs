{
  src,
  version,
  lib,
  rustPlatform,
  perl,
  tomlq,
  postgresql,
  postgresqlTestHook,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxibooru-server";
  inherit version;

  src = "${src}/server";

  cargoHash = "sha256-hQ+3iywh0mJVuVRZy+Qn2RWtQlyPK+nTafSQb5CnKig=";

  nativeBuildInputs = [
    perl
    tomlq
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  env = {
    postgresqlEnableTCP = 1;
    postgresqlTestUserOptions = "SUPERUSER LOGIN PASSWORD 'test'";
  };

  postPatch = ''
    echo "POSTGRES_DB=$PGDATABASE" >> .env
    echo "POSTGRES_USER=$PGUSER" >> .env
    echo "POSTGRES_PASSWORD=test" >> .env
  '';

  # Fixes most of the tests
  dontUseCargoParallelTests = true;

  checkFlags = [
    # Fails because of the order of the other tests
    "--skip=api::pool::test::unicode_edge_cases"
    "--skip=api::pool_category::test::list"
    "--skip=api::pool_category::test::set_default"
    "--skip=api::post::test::unicode_edge_cases"
    "--skip=api::tag::test::blacklist_edge_case"
    "--skip=api::tag::test::list"
    "--skip=api::tag::test::unicode_edge_cases"
    "--skip=api::tag_category::test::blacklist_edge_case"
    "--skip=api::tag_category::test::list"
    "--skip=api::tag_category::test::preferences"
    "--skip=api::tag_category::test::set_default"
  ];

  passthru.tests.oxibooru = nixosTests.oxibooru;

  meta = {
    description = "Server of Oxibooru, an image board engine based on Szurubooru";
    homepage = "https://github.com/rr-/szurubooru";
    license = lib.licenses.gpl3;
    mainProgram = "oxibooru_server";
    maintainers = with lib.maintainers; [ ratcornu ];
  };
})
