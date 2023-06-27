{ lib
, fetchFromGitHub
, buildPgxExtension
, postgresql
, nixosTests
, cargo-pgx_0_7_1
, nix-update-script
, stdenv
}:

(buildPgxExtension.override {cargo-pgx = cargo-pgx_0_7_1;})rec {
  inherit postgresql;

  pname = "timescaledb_toolkit";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    rev = version;
    sha256 = "sha256-aivGURTsm0dGaFq75qR3wIkXwsbvBiDEg+qLMcqKMj8=";
  };

  cargoSha256 = "sha256-AO5nSgQYvTmohXbzjWvDylnBgS2WpKP6wFOnkUx7ksI=";
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
