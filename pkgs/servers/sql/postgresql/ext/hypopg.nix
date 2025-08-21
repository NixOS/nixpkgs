{
  fetchFromGitHub,
  gitUpdater,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "hypopg";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    tag = finalAttrs.version;
    hash = "sha256-J1ltvNHB2v2I9IbYjM8w2mhXvBX31NkMasCL0O7bV8w=";
  };

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "beta";
    };
  };

  meta = {
    description = "Hypothetical Indexes for PostgreSQL";
    homepage = "https://hypopg.readthedocs.io";
    changelog = "https://github.com/HypoPG/hypopg/releases/tag/${finalAttrs.version}";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ bbigras ];
  };
})
