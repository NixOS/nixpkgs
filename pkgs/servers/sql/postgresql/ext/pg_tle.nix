{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension rec {
  pname = "pg_tle";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "pg_tle";
    tag = "v${version}";
    hash = "sha256-Z0x+66OmtD4jOdgpjjIj5OfLitcrvAssRBS7Y2dBfOk=";
  };

  buildInputs = postgresql.buildInputs;

  meta = {
    description = "Framework for building trusted language extensions for PostgreSQL";
    homepage = "https://github.com/aws/pg_tle";
    changelog = "https://github.com/aws/pg_tle/releases/tag/v${version}";
    maintainers = [ lib.maintainers.benchand ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
}
