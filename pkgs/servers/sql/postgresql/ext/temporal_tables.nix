{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "temporal_tables";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "arkhipov";
    repo = "temporal_tables";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+DCSPAPhsokWDq/5IXNhd7jY6FfzxxUjlsg/VJeD3k=";
  };

  meta = {
    description = "Temporal Tables PostgreSQL Extension";
    homepage = "https://github.com/arkhipov/temporal_tables";
    maintainers = with lib.maintainers; [ ggpeti ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd2;
  };
})
