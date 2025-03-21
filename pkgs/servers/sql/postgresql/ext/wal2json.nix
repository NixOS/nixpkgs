{
  fetchFromGitHub,
  lib,
  nixosTests,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension rec {
  pname = "wal2json";
  version = "${builtins.replaceStrings [ "_" ] [ "." ] (
    lib.strings.removePrefix "wal2json_" src.rev
  )}";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "wal2json";
    tag = "wal2json_2_6";
    hash = "sha256-+QoACPCKiFfuT2lJfSUmgfzC5MXf75KpSoc2PzPxKyM=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.tests = nixosTests.postgresql.wal2json.passthru.override postgresql;

  meta = {
    description = "PostgreSQL JSON output plugin for changeset extraction";
    homepage = "https://github.com/eulerto/wal2json";
    changelog = "https://github.com/eulerto/wal2json/releases/tag/${src.rev}";
    maintainers = with lib.maintainers; [ euank ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
  };
}
