{ lib, stdenv, fetchFromGitHub, cmake, postgresql, openssl, libkrb5 }:

# # To enable on NixOS:
# config.services.postgresql = let
#   # The postgresql pkgs has to be taken from the
#   # postgresql package used, so the extensions
#   # are built for the correct postgresql version.
#   postgresqlPackages = config.services.postgresql.package.pkgs;
# in {
#   extraPlugins = with postgresqlPackages; [ timescaledb ];
#   settings.shared_preload_libraries = "timescaledb";
# }

stdenv.mkDerivation rec {
  pname = "timescaledb";
  version = "2.9.2";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql openssl libkrb5 ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    sha256 = "sha256-3n3nqAVow8nIocXPsgCZcNkV+jr/G5/CmnSUfj2WMWo=";
  };

  cmakeFlags = [ "-DSEND_TELEMETRY_DEFAULT=OFF" "-DREGRESS_CHECKS=OFF" "-DTAP_CHECKS=OFF" ]
    ++ lib.optionals stdenv.isDarwin [ "-DLINTER=OFF" ];

  # Fix the install phase which tries to install into the pgsql extension dir,
  # and cannot be manually overridden. This is rather fragile but works OK.
  postPatch = ''
    for x in CMakeLists.txt sql/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace 'DESTINATION "''${PG_SHAREDIR}/extension"' "DESTINATION \"$out/share/postgresql/extension\""
    done

    for x in src/CMakeLists.txt src/loader/CMakeLists.txt tsl/src/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace 'DESTINATION ''${PG_PKGLIBDIR}' "DESTINATION \"$out/lib\""
    done
  '';

  meta = with lib; {
    description = "Scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage = "https://www.timescale.com/";
    changelog = "https://github.com/timescale/timescaledb/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
    broken = versionOlder postgresql.version "12";
  };
}
