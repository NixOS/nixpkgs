{
  buildPgrxExtension,
  cargo-pgrx_0_19_1,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlTestExtension,
  tzdata,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_19_1;

  pname = "pg_when";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "pg-when";
    tag = finalAttrs.version;
    hash = "sha256-XNQY0og2ywLmy8F/jUQglJyL/s1lvL28ij32WFLEvyc=";
  };

  cargoHash = "sha256-iF8BH8oaWtDF5yC//p1eE9gvrYE0hZkGAnAiGljtnI4=";

  # pgrx tests try to install the extension into the postgresql nix store
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;

    # timezone lookups need an IANA time zone database
    env.TZDIR = "${tzdata}/share/zoneinfo";

    sql = ''
      CREATE EXTENSION pg_when;
    '';
    asserts = [
      {
        query = "when_is('December 31, 2026 at evening in Asia/Tokyo')";
        expected = "TIMESTAMPTZ '2026-12-31 18:00:00+09'";
        description = "exact date with a time keyword and a named timezone resolves correctly";
      }
      {
        query = "seconds_at('January 1, 2000 at midnight in UTC+3')";
        expected = "946674000";
        description = "UNIX timestamp accounts for the UTC offset";
      }
      {
        query = "millis_at('1970-01-01 at midnight')";
        expected = "0";
        description = "UNIX epoch is zero milliseconds";
      }
    ];
  };

  meta = {
    description = "PostgreSQL extension for creating time values with natural language";
    homepage = "https://github.com/frectonz/pg-when";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frectonz ];
    platforms = postgresql.meta.platforms;
  };
})
