{ lib
, fetchFromGitHub
, buildPgrxExtension
, postgresql
, nixosTests
, cargo-pgrx
, fetchCrate
, nix-update-script
, stdenv
}:

let
  cargo-pgrx_0_10_2 = cargo-pgrx.overrideAttrs (old: rec {
    name = "cargo-pgrx-${version}";
    version = "0.10.2";

    src = fetchCrate {
      pname = "cargo-pgrx";
      inherit version;
      hash = "sha256-FqjfbJmSy5UCpPPPk4bkEyvQCnaH9zYtkI7txgIn+ls=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (_: {
      inherit src;
      outputHash = "sha256-XyI3RaPI3Edm/tCP2xoZemib2d2n2cAhobgk9Oafg6s=";
    });
  });

in

(buildPgrxExtension.override { cargo-pgrx = cargo-pgrx_0_10_2; }) rec {
  inherit postgresql;

  pname = "timescaledb_toolkit";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    rev = version;
    hash = "sha256-Lm/LFBkG91GeWlJL9RBqP8W0tlhBEeGQ6kXUzzv4xRE=";
  };

  cargoHash = "sha256-LME8oftHmmiN8GU3eTBTSB6m0CE+KtDFRssL1g2Cjm8=";
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
    broken = versionOlder postgresql.version "12" || stdenv.isDarwin;
  };
}
