{
  buildPgrxExtension,
  cargo-pgrx_0_19_1,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlTestExtension,
  unstableGitUpdater,
}:

buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_19_1;

  pname = "lead";
  version = "1.0.6-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "lead";
    rev = "e3ed2f4ce1388167b0254a0c0c706a61d0a37d83";
    hash = "sha256-cS9aeqzyaMlPA/2gfGy+D9HBWAg6O1WJRb3Fj2JlR7A=";
  };

  cargoHash = "sha256-6mPata6OToUzQfIRQOI3/KeaMOzNkdFQ+YH6mVu/l4E=";

  cargoPgrxFlags = [
    "--package"
    "tin"
  ];
  buildFeatures = [ "pg${lib.versions.major postgresql.version}" ];

  # pgrx tests try to install the extension into the postgresql nix store
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION tin;
      CREATE TABLE docs (body text);
      CREATE INDEX ON docs USING tin (body);
      INSERT INTO docs VALUES ('hello world'), ('goodbye moon');
    '';
    asserts = [
      {
        query = "SELECT count(*) FROM docs WHERE body ==> 'hello'";
        expected = "1";
        description = "tin search matches a single document";
      }
    ];
  };

  meta = {
    description = "Non-production Postgres text-search extension for using PlanetScale TIN in development";
    homepage = "https://github.com/planetscale/lead";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nkalupahana ];
    platforms = postgresql.meta.platforms;
    broken =
      !(lib.elem (lib.versions.major postgresql.version) [
        "17"
        "18"
      ]);
  };
})
