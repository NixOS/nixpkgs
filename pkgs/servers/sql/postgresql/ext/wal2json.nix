{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "wal2json";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "wal2json";
    rev = "wal2json_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-+QoACPCKiFfuT2lJfSUmgfzC5MXf75KpSoc2PzPxKyM=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  passthru.tests.wal2json = lib.recurseIntoAttrs (
    callPackage ../../../../../nixos/tests/postgresql-wal2json.nix {
      inherit (stdenv) system;
      inherit postgresql;
    }
  );

  meta = with lib; {
    description = "PostgreSQL JSON output plugin for changeset extraction";
    homepage = "https://github.com/eulerto/wal2json";
    changelog = "https://github.com/eulerto/wal2json/releases/tag/wal2json_${version}";
    maintainers = with maintainers; [ euank ];
    platforms = postgresql.meta.platforms;
    license = licenses.bsd3;
  };
}
