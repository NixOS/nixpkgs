{ lib
, fetchFromGitHub
, fetchpatch
, buildPgrxExtension
, postgresql
, nixosTests
, cargo-pgrx_0_11_3
, fetchCrate
, nix-update-script
, stdenv
}:

(buildPgrxExtension.override { cargo-pgrx = cargo-pgrx_0_11_3; }) rec {
  inherit postgresql;

  pname = "timescaledb_toolkit";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    rev = version;
    hash = "sha256-Lm/LFBkG91GeWlJL9RBqP8W0tlhBEeGQ6kXUzzv4xRE=";
  };

  # TODO: Remove this patch when upstream updates to a newer pgrx version.
  cargoPatches = [
    (fetchpatch {
      name = "cargo-pgrx-0.11.3.patch";
      url = "https://github.com/sdier/timescaledb-toolkit/commit/c05d87f33516a25a5346fe67ed43e98786204ab1.patch";
      hash = "sha256-Y2mLI1cDmx47Kgf6f/FS1ziNtcGEju+wSkegl0qwOhE=";
    })
  ];

  cargoHash = "sha256-3FJW7y+RH++6dkcs3CskKvPAmqpZX8rsBGoHcxUcQYY=";
  buildAndTestSubdir = "extension";

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      timescaledb_toolkit = nixosTests.timescaledb;
    };
  };

  # tests take really long
  doCheck = false;

  meta = with lib; {
    description = "Provide additional tools to ease all things analytic when using TimescaleDB";
    homepage = "https://github.com/timescale/timescaledb-toolkit";
    maintainers = with maintainers; [ typetetris ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;

    # as it needs to be used with timescaledb, simply use the condition from there
    broken = stdenv.isDarwin;
  };
}
