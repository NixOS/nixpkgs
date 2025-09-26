{
  fetchFromGitHub,
  lib,
  nix-update-script,
  nixosTests,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "wal2json";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "wal2json";
    tag = "wal2json_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-+QoACPCKiFfuT2lJfSUmgfzC5MXf75KpSoc2PzPxKyM=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^wal2json_(\\d+)_(\\d+)$" ];
  };
  passthru.tests = nixosTests.postgresql.wal2json.passthru.override postgresql;

  meta = {
    description = "PostgreSQL JSON output plugin for changeset extraction";
    homepage = "https://github.com/eulerto/wal2json";
    changelog = "https://github.com/eulerto/wal2json/releases/tag/${finalAttrs.src.rev}";
    maintainers = with lib.maintainers; [ euank ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
  };
})
