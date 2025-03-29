{
  fetchFromGitHub,
  gitUpdater,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  stdenv,
  testers,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_repack";
  version = "1.5.2";

  buildInputs = postgresql.buildInputs;

  src = fetchFromGitHub {
    owner = "reorg";
    repo = "pg_repack";
    tag = "ver_${finalAttrs.version}";
    hash = "sha256-wfjiLkx+S3zVrAynisX1GdazueVJ3EOwQEPcgUQt7eA=";
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "ver_";
  };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      sql = "CREATE EXTENSION pg_repack;";
    };
  };

  meta = {
    description = "Reorganize tables in PostgreSQL databases with minimal locks";
    longDescription = ''
      pg_repack is a PostgreSQL extension which lets you remove bloat from tables and indexes, and optionally restore
      the physical order of clustered indexes. Unlike CLUSTER and VACUUM FULL it works online, without holding an
      exclusive lock on the processed tables during processing. pg_repack is efficient to boot,
      with performance comparable to using CLUSTER directly.
    '';
    homepage = "https://github.com/reorg/pg_repack";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danbst ];
    inherit (postgresql.meta) platforms;
    mainProgram = "pg_repack";
  };
})
