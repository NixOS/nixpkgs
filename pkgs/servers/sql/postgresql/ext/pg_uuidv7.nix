{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_uuidv7";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "fboulnois";
    repo = "pg_uuidv7";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lG6dCnbLALnfQc4uclqXXXfYjK/WXLV0lo5I8l1E5p4=";
  };

  meta = {
    description = "Tiny Postgres extension to create version 7 UUIDs";
    homepage = "https://github.com/fboulnois/pg_uuidv7";
    changelog = "https://github.com/fboulnois/pg_uuidv7/blob/main/CHANGELOG.md";
    maintainers = with lib.maintainers; [ gaelreyrol ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mpl20;
  };
})
