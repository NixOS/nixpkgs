{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-edNqeeO2VHkoIbvpmGCkpVAF6jRNL7MqetS2I5Sjhl4=";
  };

  meta = {
    description = "RoaringBitmap extension for PostgreSQL";
    homepage = "https://github.com/ChenHuajun/pg_roaringbitmap";
    changelog = "https://github.com/ChenHuajun/pg_roaringbitmap/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
})
