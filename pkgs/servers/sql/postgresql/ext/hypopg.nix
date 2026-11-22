{
  fetchFromGitHub,
  gitUpdater,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "hypopg";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    tag = finalAttrs.version;
    hash = "sha256-uxUHGBPLnSk59A4/EYQVIDqXa5zi0mCw2MX6jfZyAPY=";
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
