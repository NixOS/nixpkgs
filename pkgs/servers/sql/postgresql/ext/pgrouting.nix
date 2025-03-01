{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  perl,
  cmake,
  boost,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
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
    rev = "v${version}";
    hash = "sha256-jaevnDCJ6hRQeDhdAkvMTvnnFWElMNvo9gZRW53proQ=";
  };

  meta = with lib; {
    description = "PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage = "https://pgrouting.org/";
    changelog = "https://github.com/pgRouting/pgrouting/releases/tag/v${version}";
    maintainers = with maintainers; teams.geospatial.members ++ [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = licenses.gpl2Plus;
  };
}
