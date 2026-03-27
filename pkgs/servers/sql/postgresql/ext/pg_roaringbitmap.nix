{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XX68Kgx9uFhnWSUIhErw3yOjo7K/seP/6oca3vS7b84=";
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
