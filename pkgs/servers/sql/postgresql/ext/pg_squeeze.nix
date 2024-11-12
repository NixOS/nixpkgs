{ lib, stdenv, fetchFromGitHub, postgresql, postgresqlTestExtension }:

stdenv.mkDerivation (finalAttrs: {
  pname = "pg_squeeze";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cybertec-postgresql";
    repo = "pg_squeeze";
    rev = "REL${builtins.replaceStrings ["."] ["_"] finalAttrs.version}";
    hash = "sha256-Kh1wSOvV5Rd1CG/na3yzbWzvaR8SJ6wmTZOnM+lbgik=";
  };

  buildInputs = [
    postgresql
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib pg_squeeze${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension pg_squeeze-*.sql
    install -D -t $out/share/postgresql/extension pg_squeeze.control

    runHook postInstall
  '';

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

  meta = with lib; {
    description = "PostgreSQL extension for automatic bloat cleanup";
    homepage = "https://github.com/cybertec-postgresql/pg_squeeze";
    changelog = "https://github.com/cybertec-postgresql/pg_squeeze/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.mit;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
  };
})
