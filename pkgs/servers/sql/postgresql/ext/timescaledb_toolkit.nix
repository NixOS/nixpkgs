{ lib
, fetchFromGitHub
, buildPgrxExtension
, postgresql
, nixosTests
, cargo-pgrx_0_12_6
, nix-update-script
}:

(buildPgrxExtension.override { cargo-pgrx = cargo-pgrx_0_12_6; }) rec {
  inherit postgresql;

  pname = "timescaledb_toolkit";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    rev = version;
    hash = "sha256-7yUbtWbYL4AnuUX8OXG4OVqYCY2Lf0pISSTlcFdPqog=";
  };

  cargoHash = "sha256-+uD4UU7QwNISQZ7a2kDkY/y3fQWk/K0fFcrFq4yq6RU=";
  buildAndTestSubdir = "extension";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.postgresql.timescaledb.passthru.override postgresql;
  };

  # tests take really long
  doCheck = false;

  meta = with lib; {
    description = "Provide additional tools to ease all things analytic when using TimescaleDB";
    homepage = "https://github.com/timescale/timescaledb-toolkit";
    maintainers = with maintainers; [ typetetris ];
    platforms = postgresql.meta.platforms;
    license = licenses.tsl;
  };
}
