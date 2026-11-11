{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension rec {
  pname = "pg_tle";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "pg_tle";
    tag = "v${version}";
    hash = "sha256-+4OO6/5pOLK2I00DHpTzw/9r+cdy82pCAE6i2/whF4A=";
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
