{
  buildPostgresqlExtension,
  cmake,
  enableUnfree ? true,
  fetchFromGitHub,
  lib,
  libkrb5,
  nixosTests,
  openssl,
  postgresql,
  stdenv,
}:

buildPostgresqlExtension rec {
  pname = "timescaledb${lib.optionalString (!enableUnfree) "-apache"}";
  version = "2.18.0";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    libkrb5
  ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    hash = "sha256-wDjzahlhUlBDXppk9HLNUOc7mlVqv56M2VGE/C04gUo=";
  };

  cmakeFlags =
    [
      "-DSEND_TELEMETRY_DEFAULT=OFF"
      "-DREGRESS_CHECKS=OFF"
      "-DTAP_CHECKS=OFF"
    ]
    ++ lib.optionals (!enableUnfree) [ "-DAPACHE_ONLY=ON" ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DLINTER=OFF" ];

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

  meta = with lib; {
    description = "Scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage = "https://www.timescale.com/";
    changelog = "https://github.com/timescale/timescaledb/blob/${version}/CHANGELOG.md";
    maintainers = [ maintainers.kirillrdy ];
    platforms = postgresql.meta.platforms;
    license = with licenses; if enableUnfree then tsl else asl20;
    broken = versionOlder postgresql.version "14";
  };
}
