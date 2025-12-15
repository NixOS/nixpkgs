{
  cargo-pgrx_0_16_0,
  jitSupport,
  lib,
  nixosTests,
  pg-dump-anon,
  postgresql,
  buildPgrxExtension,
  runtimeShell,
}:

buildPgrxExtension {
  pname = "postgresql_anonymizer";

  inherit (pg-dump-anon) version src;

  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_16_0;
  cargoHash = "sha256-Z1uH6Z2qLV1Axr8dXqPznuEZcacAZnv11tb3lWBh1yw=";

  # Tries to copy extension into postgresql's store path.
  doCheck = false;

  passthru.tests = nixosTests.postgresql.anonymizer.passthru.override postgresql;

  meta = {
    inherit (pg-dump-anon.meta) homepage teams license;
    description = "Extension to mask or replace personally identifiable information (PII) or commercially sensitive data from a PostgreSQL database";
  };
}
