{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  gitUpdater,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "hypopg";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    rev = version;
    hash = "sha256-88uKPSnITRZ2VkelI56jZ9GWazG/Rn39QlyHKJKSKMM=";
  };

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "beta";
    };
  };

  meta = with lib; {
    description = "Hypothetical Indexes for PostgreSQL";
    homepage = "https://hypopg.readthedocs.io";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ bbigras ];
  };
}
