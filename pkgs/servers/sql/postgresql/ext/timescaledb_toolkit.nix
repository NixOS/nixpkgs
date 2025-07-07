{
  buildPgrxExtension,
  cargo-pgrx_0_12_6,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
}:

buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_12_6;

  pname = "timescaledb_toolkit";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-gGGSNvvJprqLkVwPr7cfmGY1qEUTXMdqdvwPYIzXaTA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kyUpfNEXJ732VO6JDxU+dIoL57uWzG4Ff03/GnvsxLE=";
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
    broken = lib.versionOlder postgresql.version "15";
  };
})
