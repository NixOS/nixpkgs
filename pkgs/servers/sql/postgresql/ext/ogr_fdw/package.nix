{
  fetchFromGitHub,
  fetchpatch2,
  gdal,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "ogr_fdw";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = "pgsql-ogr-fdw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S9WowU0kZZD15cqLQXo6j4M+HP8ESvH7Drp3SW5HqTU=";
  };

  # see https://github.com/pramsey/pgsql-ogr-fdw/pull/280
  patches = [ ./fix_makefile_install.patch ];

  # for gdal-config
  nativeBuildInputs = [ gdal ];

  meta = {
    description = "PostgreSQL foreign data wrapper for OGR";
    homepage = "https://github.com/pramsey/pgsql-ogr-fdw";
    changelog = "https://github.com/pramsey/pgsql-ogr-fdw/releases/tag/v${finalAttrs.version}";
    teams = [ lib.teams.geospatial ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
