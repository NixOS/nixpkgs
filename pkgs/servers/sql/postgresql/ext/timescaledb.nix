{ stdenv, fetchFromGitHub, cmake, postgresql, openssl }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  name = "timescaledb-${version}";
  version = "1.3.2";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql openssl ];

  src = fetchFromGitHub {
    owner  = "timescale";
    repo   = "timescaledb";
    rev    = "refs/tags/${version}";
    sha256 = "117az52h8isi15p47r5d6k5y80ng9vj3x8ljq39iavgr364q716c";
  };

  cmakeFlags = [ "-DSEND_TELEMETRY_DEFAULT=OFF" ];

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

  postInstall = ''
    # work around an annoying bug, by creating $out/bin, so buildEnv doesn't freak out later
    # see https://github.com/NixOS/nixpkgs/issues/22653

    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage    = https://www.timescale.com/;
    maintainers = with maintainers; [ volth ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
