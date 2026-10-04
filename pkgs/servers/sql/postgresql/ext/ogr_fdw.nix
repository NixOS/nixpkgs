{
  fetchFromGitHub,
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

  # for gdal-config
  nativeBuildInputs = [ gdal ];

  postInstall = ''
    # upstream install target seems to be broken
    mv -v $out/bin $out/ogr_fdw_info
    mkdir -v $out/bin
    mv -v $out/ogr_fdw_info $out/bin
  '';

  meta = {
    description = "PostgreSQL foreign data wrapper for OGR";
    homepage = "https://github.com/pramsey/pgsql-ogr-fdw";
    changelog = "https://github.com/pramsey/pgsql-ogr-fdw/releases/tag/v${finalAttrs.version}";
    teams = [ lib.teams.geospatial ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
