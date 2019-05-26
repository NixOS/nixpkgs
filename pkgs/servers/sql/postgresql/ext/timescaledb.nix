{ stdenv, fetchFromGitHub, cmake, postgresql, openssl }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  name = "timescaledb-${version}";
  version = "1.3.0";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ postgresql openssl ];

  src = fetchFromGitHub {
    owner  = "timescale";
    repo   = "timescaledb";
    rev    = "refs/tags/${version}";
    sha256 = "1wg95ryr5z55aghlqaz0jhz6rliinvfin2i4xpqwg7ir6nz773qm";
  };

  # Fix the install phase which tries to install into the pgsql extension dir,
  # and cannot be manually overridden. This is rather fragile but works OK.
  patchPhase = ''
    for x in CMakeLists.txt sql/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace 'DESTINATION "''${PG_SHAREDIR}/extension"' "DESTINATION \"$out/share/extension\""
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
