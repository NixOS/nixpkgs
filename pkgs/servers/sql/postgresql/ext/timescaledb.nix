{
  cmake,
  fetchFromGitHub,
  lib,
  libkrb5,
  nixosTests,
  openssl,
  postgresql,
  postgresqlBuildExtension,
  stdenv,

  enableUnfree ? true,
}:

postgresqlBuildExtension rec {
  pname = "timescaledb${lib.optionalString (!enableUnfree) "-apache"}";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    tag = version;
    hash = "sha256-8E5oEEsyu247WtmR20xRO/SAI6KXYSVCrU0qta6iUB8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    libkrb5
  ];

  cmakeFlags = [
    (lib.cmakeBool "SEND_TELEMETRY_DEFAULT" false)
    (lib.cmakeBool "REGRESS_CHECKS" false)
    (lib.cmakeBool "TAP_CHECKS" false)
    (lib.cmakeBool "APACHE_ONLY" (!enableUnfree))
  ];

  # Fix the install phase which tries to install into the pgsql extension dir,
  # and cannot be manually overridden. This is rather fragile but works OK.
  postPatch = ''
    for x in CMakeLists.txt sql/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace-fail 'DESTINATION "''${PG_SHAREDIR}/extension"' "DESTINATION \"$out/share/postgresql/extension\""
    done

    for x in src/CMakeLists.txt src/loader/CMakeLists.txt tsl/src/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace-fail 'DESTINATION ''${PG_PKGLIBDIR}' "DESTINATION \"$out/lib\""
    done
  '';

  passthru.tests = nixosTests.postgresql.timescaledb.passthru.override postgresql;

  meta = {
    description = "Scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage = "https://www.timescale.com/";
    changelog = "https://github.com/timescale/timescaledb/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ kirillrdy ];
    platforms = postgresql.meta.platforms;
    license = with lib.licenses; if enableUnfree then tsl else asl20;
    broken = lib.versionOlder postgresql.version "14";
  };
}
