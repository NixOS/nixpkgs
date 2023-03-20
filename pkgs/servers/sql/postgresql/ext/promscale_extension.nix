{ lib
, fetchFromGitHub
, fetchpatch
, buildPgxExtension
, postgresql
, stdenv
, nixosTests
}:

buildPgxExtension rec {
  inherit postgresql;

  pname = "promscale_extension";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "promscale_extension";
    rev = version;
    sha256 = "sha256-vyEfQMGguHrHYdBEEmbev29L2uCa/4xL9DpGIniUwfI=";
  };

  cargoSha256 = "sha256-vq/R9Kd0a9ckgEYm9Kt2J+RdyiHHYVutNEM4dcRViUo=";

  cargoPatches = [
    # there is a duplicate definition in the lock file which fails to build with buildRustPackage
    (fetchpatch {
      name = "cargo-vendor.patch";
      url = "https://github.com/timescale/promscale_extension/commit/3cef3f26f72ebf52d8800910ea655cac09312c57.patch";
      hash = "sha256-bXwvOv6T09EsCu+QCOCZny+V/Cy1UvCP6zlE8TdBlEg=";
    })
  ];

  preBuild = ''
    patchShebangs create-upgrade-symlinks.sh extract-extension-version.sh
    ## Hack to boostrap the build because some pgx commands require this file. It gets re-generated later.
    cp templates/promscale.control ./promscale.control
  '';
  postInstall = ''
    ln -s $out/lib/promscale-${version}.so $out/lib/promscale.so
  '';
  passthru.tests = {
    promscale = nixosTests.promscale;
  };

  # tests take really long
  doCheck = false;

  meta = with lib; {
    description = "Promscale is an open source observability backend for metrics and traces powered by SQL";
    homepage = "https://github.com/timescale/promscale_extension";
    maintainers = with maintainers; [ anpin ];
    platforms = postgresql.meta.platforms;
    license = licenses.unfree;

    # as it needs to be used with timescaledb, simply use the condition from there
    broken = versionOlder postgresql.version "12"
             || versionAtLeast postgresql.version "15";
  };
}
