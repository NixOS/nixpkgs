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
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dyDAJUqEuf57hHUhqJdr2b5BJxjGCbQuH6GtPgtVmE8=";
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
