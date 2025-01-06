{
  lib,
  buildPgrxExtension,
  fetchFromGitHub,
  nix-update-script,
  postgresql,
  util-linux,
}:
buildPgrxExtension rec {
  inherit postgresql;

  pname = "pgx_ulid";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pksunkara";
    repo = "pgx_ulid";
    tag = "v${version}";
    hash = "sha256-VdLWwkUA0sVs5Z/Lyf5oTRhcHVzPmhgnYQhIM8MWJ0c=";
  };

  cargoHash = "sha256-Gn+SjzGaxnGKJYI9+WyE1+TzlF/2Ne43aKbXrSzfQKM=";

  postInstall = ''
    # Upstream renames the extension when packaging
    # https://github.com/pksunkara/pgx_ulid/blob/084778c3e2af08d16ec5ec3ef4e8f345ba0daa33/.github/workflows/release.yml#L81
    # Upgrade scripts should be added later, so we also rename them with wildcard
    # https://github.com/pksunkara/pgx_ulid/issues/49
    ${util-linux}/bin/rename pgx_ulid ulid $out/share/postgresql/extension/pgx_ulid*
  '';

  # pgrx tests try to install the extension into postgresql nix store
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    # Support for PostgreSQL 13 was removed in 0.2.0: https://github.com/pksunkara/pgx_ulid/blob/084778c3e2af08d16ec5ec3ef4e8f345ba0daa33/CHANGELOG.md?plain=1#L6
    broken = lib.versionOlder postgresql.version "14";
    description = "ULID Postgres extension written in Rust";
    homepage = "https://github.com/pksunkara/pgx_ulid";
    changelog = "https://github.com/pksunkara/pgx_ulid/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ myypo ];
  };
}
