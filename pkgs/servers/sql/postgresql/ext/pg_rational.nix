{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_rational";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "begriffs";
    repo = "pg_rational";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sp5wuX2nP3KGyWw7MFa11rI1CPIKIWBt8nvBSsASIEw=";
  };

  meta = {
    description = "Precise fractional arithmetic for PostgreSQL";
    homepage = "https://github.com/begriffs/pg_rational";
    maintainers = with lib.maintainers; [ netcrns ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
