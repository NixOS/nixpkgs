{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_auto_failover";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "pg_auto_failover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsnVry+5n08kLOun8u0B7XFvI5ijTKJtFJ84fixMHe4=";
  };

  buildInputs = postgresql.buildInputs;

  meta = {
    description = "PostgreSQL extension and service for automated failover and high-availability";
    mainProgram = "pg_autoctl";
    homepage = "https://github.com/citusdata/pg_auto_failover";
    changelog = "https://github.com/citusdata/pg_auto_failover/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
