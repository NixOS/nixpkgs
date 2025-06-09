{
  fetchFromGitHub,
  gitUpdater,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "hypopg";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    tag = finalAttrs.version;
    hash = "sha256-88uKPSnITRZ2VkelI56jZ9GWazG/Rn39QlyHKJKSKMM=";
  };

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "beta";
    };
  };

  meta = {
    description = "Hypothetical Indexes for PostgreSQL";
    homepage = "https://hypopg.readthedocs.io";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ bbigras ];
  };
})
