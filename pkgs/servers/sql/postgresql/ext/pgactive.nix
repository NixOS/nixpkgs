{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  pkg-config,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "pgactive";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "pgactive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tiCd0YepVz4ZA62OaTtwLUhWG4pR4K6xg6BuyZK+iWc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  postPatch = ''
    touch .distgitrev
  '';

  buildInputs = postgresql.buildInputs;

  passthru.tests = {
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;

      # Needed for pgactive to boot successfully.
      postgresqlExtraSettings = ''
        shared_preload_libraries = 'pgactive'
        track_commit_timestamp = 'on'
        wal_level = 'logical'
      '';

      sql = ''
        CREATE EXTENSION pgactive;
      '';
    };
  };

  meta = {
    description = "Active-active Replication Extension for PostgreSQL";
    homepage = "https://github.com/aws/pgactive";
    changelog = "https://github.com/aws/pgactive/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ sjcobb ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
