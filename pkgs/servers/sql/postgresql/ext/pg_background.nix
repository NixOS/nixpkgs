{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  openssl,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_background";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "vibhorkum";
    repo = "pg_background";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UbqMz7s4rSr7kKeZb+UVMc2Xg2r5GuM34SxI6DEIMPg=";
  };

  buildInputs = postgresql.buildInputs;

  meta = {
    description = "Run PostgreSQL Commands in Background Workers";
    homepage = "https://github.com/vibhorkum/pg_background";
    changelog = "https://github.com/vibhorkum/pg_background/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ mkleczek ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl3Only;
  };
})
