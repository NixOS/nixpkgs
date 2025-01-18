{
  lib,
  fetchFromGitHub,
  postgresql,
  postgresqlTestExtension,
  testers,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension (finalAttrs: {
  pname = "pg-semver";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pg-semver";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9f+QuGupjTUK3cQk7DFDrL7MOIwDE9SAUyVZ9RfrdDM=";
  };

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      sql = "CREATE EXTENSION semver;";
    };
  };

  meta = with lib; {
    description = "Semantic version data type for PostgreSQL";
    homepage = "https://github.com/theory/pg-semver";
    changelog = "https://github.com/theory/pg-semver/blob/main/Changes";
    maintainers = with maintainers; [ grgi ];
    inherit (postgresql.meta) platforms;
    license = licenses.postgresql;
  };
})
