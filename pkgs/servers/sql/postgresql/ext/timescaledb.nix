{ lib, stdenv, fetchFromGitHub, cmake, postgresql, openssl, libkrb5, fetchpatch }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  pname = "timescaledb";
  version = "2.8.1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql openssl libkrb5 ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    sha256 = "sha256-2ayWm1lXR1rgDHdpKO0gMJzGRag95qVPU7jSCJRtar0=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-25149.patch";
      url = "https://github.com/timescale/timescaledb/commit/789bb26dfbf1aaf85163e5ddfc70fa6dae0894fb.patch";
      excludes = [
        "CHANGELOG.md"
        # 2.8.1 doesn't yet have any SPI calls in this file to protect. a cursory
        # audit of the full source shows no unprotected SPI_connect/ext calls once
        # this patch is applied
        "src/telemetry/telemetry.c"
      ];
      sha256 = "sha256-AaikftbXMQPnBo6BT6Nad05X40/hZpqpuC4gXWk6hgk=";
    })
  ];

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
