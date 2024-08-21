{ lib, stdenv, fetchFromGitHub, postgresql, postgresqlTestHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "pg_squeeze";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "cybertec-postgresql";
    repo = "pg_squeeze";
    rev = "REL${builtins.replaceStrings ["."] ["_"] finalAttrs.version}";
    hash = "sha256-YS13iIpQ4NJe0N6bRVa2RDxEMwEzBc2mjNYM5/Vqjn8=";
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

  passthru.tests.extension = stdenv.mkDerivation {
    name = "pg_squeeze-test";
    dontUnpack = true;
    doCheck = true;
    nativeCheckInputs = [ postgresqlTestHook (postgresql.withPackages (_: [ finalAttrs.finalPackage ])) ];
    failureHook = "postgresqlStop";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    postgresqlExtraSettings = ''
      wal_level = logical
      shared_preload_libraries = 'pg_squeeze'
    '';
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION pg_squeeze;

      SELECT squeeze.start_worker();

      CREATE TABLE a(i int PRIMARY KEY, j int);
      INSERT INTO a(i, j) SELECT x, x FROM generate_series(1, 20) AS g(x);
      INSERT INTO squeeze.tables (tabschema, tabname, schedule)
      VALUES ('public', 'a', ('{30}', '{22}', NULL, NULL, '{3, 5}'));
      SELECT squeeze.squeeze_table('public', 'a', NULL, NULL, NULL);
    '';
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -f $sqlPath
      runHook postCheck
    '';
    installPhase = "touch $out";
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
