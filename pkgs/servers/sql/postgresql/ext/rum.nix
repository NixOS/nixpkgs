{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  postgresqlTestHook,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension (finalAttrs: {
  pname = "rum";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    rev = finalAttrs.version;
    hash = "sha256-VsfpxQqRBu9bIAP+TfMRXd+B3hSjuhU2NsutocNiCt8=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.tests.extension = stdenv.mkDerivation {
    inherit (finalAttrs) version;
    pname = "rum-test";

    dontUnpack = true;
    doCheck = true;
    nativeCheckInputs = [
      postgresqlTestHook
      (postgresql.withPackages (_: [ finalAttrs.finalPackage ]))
    ];
    failureHook = "postgresqlStop";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION rum;
      CREATE TABLE test_table (t text, v tsvector);
      CREATE INDEX test_table_rumindex ON test_table USING rum (v rum_tsvector_ops);
    '';
    checkPhase = ''
      runHook preCheck

      psql -a -v ON_ERROR_STOP=1 -f $sqlPath

      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  meta = with lib; {
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
})
