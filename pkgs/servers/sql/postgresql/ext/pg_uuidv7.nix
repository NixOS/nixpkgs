{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_uuidv7";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "fboulnois";
    repo = "pg_uuidv7";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hF0Kk1j7QBC7nlJ+32e0LICzG/fX61LpwqslUrOOXbM=";
  };

  meta = {
    description = "Tiny Postgres extension to create version 7 UUIDs";
    homepage = "https://github.com/fboulnois/pg_uuidv7";
    changelog = "https://github.com/fboulnois/pg_uuidv7/blob/main/CHANGELOG.md";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mpl20;
  };
})
