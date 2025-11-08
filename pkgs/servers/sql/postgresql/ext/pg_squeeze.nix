{
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_squeeze";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "cybertec-postgresql";
    repo = "pg_squeeze";
    tag = "REL${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-KbCS3kg2MoxKHl+35UOFCSF4kPPsIMeO7AfwfHZYZVg=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^REL(\\d+)_(\\d+)_(\\d+)$" ];
  };
  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    postgresqlExtraSettings = ''
      wal_level = logical
      shared_preload_libraries = 'pg_squeeze'
    '';
    sql = ''
      CREATE EXTENSION pg_squeeze;

      SELECT squeeze.start_worker();

      CREATE TABLE a(i int PRIMARY KEY, j int);
      INSERT INTO a(i, j) SELECT x, x FROM generate_series(1, 20) AS g(x);
      INSERT INTO squeeze.tables (tabschema, tabname, schedule)
      VALUES ('public', 'a', ('{30}', '{22}', NULL, NULL, '{3, 5}'));
      SELECT squeeze.squeeze_table('public', 'a', NULL, NULL, NULL);
    '';
  };

  meta = {
    description = "PostgreSQL extension for automatic bloat cleanup";
    homepage = "https://github.com/cybertec-postgresql/pg_squeeze";
    changelog = "https://github.com/cybertec-postgresql/pg_squeeze/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
  };
})
