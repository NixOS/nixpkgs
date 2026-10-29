{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hc1R2gUfLPDHhgNUq732DxQCWbQ2A3DtVAEti8XZGho=";
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
