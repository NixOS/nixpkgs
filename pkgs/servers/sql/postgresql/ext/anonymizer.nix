{
  cargo-pgrx_0_19_0,
  fetchFromGitLab,
  jitSupport,
  lib,
  nixosTests,
  nix-update-script,
  postgresql,
  buildPgrxExtension,
  runtimeShell,
}:

buildPgrxExtension (finalAttrs: {
  pname = "postgresql_anonymizer";
  version = "3.2.2";

  src = fetchFromGitLab {
    owner = "dalibo";
    repo = "postgresql_anonymizer";
    tag = finalAttrs.version;
    hash = "sha256-no457Cb6SC6ji1iUbRARP9xESgWERjy8OTtGk8hzmrU=";
  };

  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_19_0;
  cargoHash = "sha256-xQvBdLfxnPw+lvCM+sepfUyGyGK8WI+6kqk4DVY7+s8=";

  # Tries to copy extension into postgresql's store path.
  doCheck = false;

  # the pg_config view is empty in nixpkgs, so anon.init() cannot locate its data
  postPatch = ''
    substituteInPlace sql/init.sql \
      --replace-fail "SELECT setting AS sharedir" "SELECT '$out/share/postgresql' AS sharedir" \
      --replace-fail "FROM pg_catalog.pg_config" "" \
      --replace-fail "WHERE name = 'SHAREDIR'" ""
  '';

  # data loaded by anon.init(), installed by upstream's Makefile
  postInstall = ''
    install -Dm644 -t $out/share/postgresql/extension/anon data/*.csv data/en_US/fake/*.csv
  '';

  passthru = {
    tests = nixosTests.postgresql.anonymizer.passthru.override postgresql;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extension to mask or replace personally identifiable information (PII) or commercially sensitive data from a PostgreSQL database";
    homepage = "https://postgresql-anonymizer.readthedocs.io/en/stable/";
    changelog = "https://gitlab.com/dalibo/postgresql_anonymizer/-/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      leona
      osnyx
    ];
    license = lib.licenses.postgresql;
  };
})
