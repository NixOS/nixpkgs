{
  boost,
  cmake,
  fetchFromGitHub,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgrouting";
  version = "4.0.1";

  nativeBuildInputs = [
    cmake
    perl
  ];
  buildInputs = [ boost ];

  src = fetchFromGitHub {
    owner = "pgRouting";
    repo = "pgrouting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3dlVcENhBveVmkuzWaLfHWy73OMDpC2FxrNQ4W6m9k=";
  };

  meta = {
    description = "PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage = "https://pgrouting.org/";
    changelog = "https://github.com/pgRouting/pgrouting/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    teams = [ lib.teams.geospatial ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl2Plus;
  };
})
