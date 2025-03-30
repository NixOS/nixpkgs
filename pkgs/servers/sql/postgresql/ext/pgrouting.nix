{
  boost,
  cmake,
  fetchFromGitHub,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pgrouting";
  version = "3.7.3";

  nativeBuildInputs = [
    cmake
    perl
  ];
  buildInputs = [ boost ];

  src = fetchFromGitHub {
    owner = "pgRouting";
    repo = "pgrouting";
    tag = "v${version}";
    hash = "sha256-jaevnDCJ6hRQeDhdAkvMTvnnFWElMNvo9gZRW53proQ=";
  };

  meta = {
    description = "PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage = "https://pgrouting.org/";
    changelog = "https://github.com/pgRouting/pgrouting/releases/tag/v${version}";
    maintainers = with lib.maintainers; lib.teams.geospatial.members ++ [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl2Plus;
  };
}
