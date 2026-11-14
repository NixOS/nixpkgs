{
  fetchFromGitHub,
  fetchpatch2,
  freetds,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "tds_fdw";
  version = "2.0.5";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner = "tds-fdw";
    repo = "tds_fdw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ecdErksaZ7SyCKzvSY5sD7rrKljq7BMn+gI9Yz49r0=";
  };

  patches = [
    # Fix build with PostgreSQL 19
    # https://github.com/tds-fdw/tds_fdw/pull/422
    (fetchpatch2 {
      url = "https://github.com/tds-fdw/tds_fdw/commit/5b8078ca8ce2007a0e4cc7eaa6ab254e335a00fa.patch";
      hash = "sha256-lqNfFjSdy8ZejyeRzyBMW8IuGHY5ShRvZfkdNDu6Rhw=";
    })
  ];

  meta = {
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage = "https://github.com/tds-fdw/tds_fdw";
    changelog = "https://github.com/tds-fdw/tds_fdw/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
