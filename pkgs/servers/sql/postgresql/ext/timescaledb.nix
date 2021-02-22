{ lib, stdenv, fetchFromGitHub, cmake, postgresql, openssl }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  pname = "timescaledb";
  version = "2.0.1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql openssl ];

  src = fetchFromGitHub {
    owner  = "timescale";
    repo   = "timescaledb";
    rev    = "refs/tags/${version}";
    sha256 = "105zc5m3zvnrqr8409qdbycb4yp7znxmna76ri1m2djkdp5rh4q1";
  };

  # -DWARNINGS_AS_ERRORS=OFF to be removed once https://github.com/timescale/timescaledb/issues/2770 is fixed in upstream
  cmakeFlags = [ "-DSEND_TELEMETRY_DEFAULT=OFF" "-DREGRESS_CHECKS=OFF" "-DWARNINGS_AS_ERRORS=OFF" ];

  # Fix the install phase which tries to install into the pgsql extension dir,
  # and cannot be manually overridden. This is rather fragile but works OK.
  patchPhase = ''
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
    homepage    = "https://www.timescale.com/";
    maintainers = with maintainers; [ volth marsam ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
