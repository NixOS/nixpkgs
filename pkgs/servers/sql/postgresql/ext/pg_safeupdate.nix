{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg-safeupdate";
  version = "1.6-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "eradman";
    repo = "pg-safeupdate";
    rev = "404fcd265f3242b432a16756bfdd078e3a4b6e0f";
    hash = "sha256-8Y27TfcY6+QO2Fb9wi6zlKzHlDdlIB38/RffMV7MPF0=";
  };

  meta = {
    description = "Simple extension to PostgreSQL that requires criteria for UPDATE and DELETE";
    homepage = "https://github.com/eradman/pg-safeupdate";
    changelog = "https://github.com/eradman/pg-safeupdate/raw/${finalAttrs.version}/NEWS";
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ wolfgangwalther ];
    license = lib.licenses.postgresql;
  };
})
