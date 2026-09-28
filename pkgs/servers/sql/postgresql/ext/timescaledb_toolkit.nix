{
  buildPgrxExtension,
  cargo-pgrx_0_18_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
}:

buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_18_0;

  pname = "timescaledb_toolkit";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-we2w2rYGRC9Did9oocgCWbIUxb8a/g0BlCHXQUe1f8I=";
  };

  cargoHash = "sha256-R6daWAQssopVps+IqF94dGBcZMC/u1J4eEg6WouAwOo=";
  buildAndTestSubdir = "extension";

  postInstall = ''
    cargo run --manifest-path ./tools/post-install/Cargo.toml -- --dir "$out"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = postgresql.pkgs.timescaledb.tests;
  };

  # tests take really long
  doCheck = false;

  meta = {
    description = "Provide additional tools to ease all things analytic when using TimescaleDB";
    homepage = "https://github.com/timescale/timescaledb-toolkit";
    maintainers = with lib.maintainers; [ typetetris ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.tsl;
    broken =
      lib.versionOlder postgresql.version "15"
      ||
        # Check after next package update.
        lib.warnIf (finalAttrs.version != "1.23.0")
          "Is postgresql19Packages.timescaledb_toolkit still broken?"
          (lib.versionAtLeast postgresql.version "19");
  };
})
