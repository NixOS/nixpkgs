{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension rec {
  pname = "pg_tle";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "pg_tle";
    tag = "v${version}";
    hash = "sha256-GuHlmFQjMr9Kv4NqIm9mcVfLc36EQVj5Iy7Kh26k0l4=";
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
