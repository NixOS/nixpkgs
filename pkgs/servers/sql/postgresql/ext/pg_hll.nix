{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_hll";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "postgresql-hll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+hMGs3jEKMUbPhR0DBGwwLczmiTriGyyvjEoReQYw/g=";
  };

  meta = {
    description = "HyperLogLog for PostgreSQL";
    homepage = "https://github.com/citusdata/postgresql-hll";
    changelog = "https://github.com/citusdata/postgresql-hll/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
