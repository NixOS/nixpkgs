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
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8G2CzzkWTKEglpUt1Gr7d/DuHJvCIEjsbYDMl3Zt3cs=";
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
