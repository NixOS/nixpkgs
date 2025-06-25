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
  version = "3.8.0";

  nativeBuildInputs = [
    cmake
    perl
  ];
  buildInputs = [ boost ];

  src = fetchFromGitHub {
    owner = "pgRouting";
    repo = "pgrouting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lvf7TQ3GywbzZmcd9wi3s8I5sCXIQAPeXNTRk/J46to=";
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
