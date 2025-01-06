{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_hll";
  version = "2.18";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "postgresql-hll";
    rev = "refs/tags/v${version}";
    hash = "sha256-Latdxph1Ura8yKEokEjalJ+/GY+pAKOT3GXjuLprj6c=";
  };

  meta = {
    description = "HyperLogLog for PostgreSQL";
    homepage = "https://github.com/citusdata/postgresql-hll";
    changelog = "https://github.com/citusdata/postgresql-hll/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
}
