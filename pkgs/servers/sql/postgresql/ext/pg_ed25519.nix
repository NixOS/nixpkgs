{
  fetchFromGitLab,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_ed25519";
  version = "0.2";

  src = fetchFromGitLab {
    owner = "dwagin";
    repo = "pg_ed25519";
    tag = finalAttrs.version;
    hash = "sha256-IOL3ogbPCMNmwDwpeaCZSoaFLJRX0Oah+ysgyUfHg5s=";
  };

  meta = {
    description = "PostgreSQL extension for signing and verifying ed25519 signatures";
    homepage = "https://gitlab.com/dwagin/pg_ed25519";
    maintainers = with lib.maintainers; [ renzo ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
    # Broken with no upstream fix available.
    broken = lib.versionAtLeast postgresql.version "16";
  };
})
