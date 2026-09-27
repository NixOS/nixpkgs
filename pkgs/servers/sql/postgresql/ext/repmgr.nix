{
  curl,
  fetchFromGitHub,
  flex,
  json_c,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "repmgr";
  version = "5.5.0+debpgdg";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E9XMUvv7GpuPqz5jvIBgxscLOMhnC0imbfQdOL2y8/s=";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = postgresql.buildInputs ++ [
    curl
    json_c
  ];

  meta = {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
})
