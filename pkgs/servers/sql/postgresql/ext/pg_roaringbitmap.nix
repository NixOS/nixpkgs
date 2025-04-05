{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestHook,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E6vqawnsRsAIajGDgJcTUWV1H8GFFboTjhmVfemUGbs=";
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
