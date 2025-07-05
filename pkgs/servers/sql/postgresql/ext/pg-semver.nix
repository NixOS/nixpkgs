{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg-semver";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pg-semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9f+QuGupjTUK3cQk7DFDrL7MOIwDE9SAUyVZ9RfrdDM=";
  };

  passthru.tests = {
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      sql = "CREATE EXTENSION semver;";
    };
  };

  meta = {
    description = "Semantic version data type for PostgreSQL";
    homepage = "https://github.com/theory/pg-semver";
    changelog = "https://github.com/theory/pg-semver/blob/main/Changes";
    maintainers = with lib.maintainers; [ grgi ];
    inherit (postgresql.meta) platforms;
    license = lib.licenses.postgresql;
  };
})
