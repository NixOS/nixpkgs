{ lib
, fetchFromGitHub
, buildPgxExtension
, postgresql
, stdenv
, nixosTests
, cargo-pgx_0_6_1
}:

(buildPgxExtension.override {cargo-pgx = cargo-pgx_0_6_1;})rec {
  inherit postgresql;

  pname = "timescaledb_toolkit";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-toolkit";
    rev = version;
    sha256 = "sha256-ADmYALsCzZGqTX0XSkCif7ndvXwa8nEqddQpty4hbZ0=";
  };

  cargoSha256 = "sha256-ukjJ11LmfG+k8D20rj68i43gOWUN80nf3hIAjUWXihI=";
  buildAndTestSubdir = "extension";

  passthru.tests = {
    timescaledb_toolkit = nixosTests.timescaledb;
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
    broken = versionOlder postgresql.version "12";
  };
}
