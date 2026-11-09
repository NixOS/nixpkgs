{
  buildPgrxExtension,
  cargo-pgrx_0_17_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  util-linux,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_17_0;

  pname = "pgx_ulid";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "pksunkara";
    repo = "pgx_ulid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4whXsKyDiV+3F5Xp5Q5vODT7LGS4IVz4VfrhsyYw14=";
  };

  cargoHash = "sha256-oQTetxtIqrVqSDcO8GEMAJ20/RKyYoBAIVflAcWHrPA=";

  postInstall = ''
    # Upstream renames the extension when packaging as well as upgrade scripts
    # https://github.com/pksunkara/pgx_ulid/blob/master/.github/workflows/release.yml#L80
    ${util-linux}/bin/rename pgx_ulid ulid $out/share/postgresql/extension/pgx_ulid*
  '';

  # pgrx tests try to install the extension into postgresql nix store
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ULID Postgres extension written in Rust";
    homepage = "https://github.com/pksunkara/pgx_ulid";
    changelog = "https://github.com/pksunkara/pgx_ulid/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      myypo
      typedrat
    ];
  };
})
