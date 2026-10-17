{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg-safeupdate";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "eradman";
    repo = "pg-safeupdate";
    tag = finalAttrs.version;
    hash = "sha256-V1P6gdFHwAFd4g8CrSRdRrL1wKs3bFfin8LLDNhZcUI=";
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
