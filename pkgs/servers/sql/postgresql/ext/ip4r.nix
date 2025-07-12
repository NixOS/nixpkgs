{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "ip4r";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "RhodiumToad";
    repo = "ip4r";
    tag = "${finalAttrs.version}";
    hash = "sha256-3chAD4f4A6VlXVSI0kfC/ANcnFy4vBp4FZpT6QRAueQ=";
  };

  passthru.tests = {
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      sql = "CREATE EXTENSION ip4r;";
    };
  };

  meta = {
    description = "IPv4/v6 and IPv4/v6 range index type for PostgreSQL";
    homepage = "https://github.com/RhodiumToad/ip4r";
    license = lib.licenses.postgresql;
    maintainers = with lib.maintainers; [ lukegb ];
    inherit (postgresql.meta) platforms;
  };
})
