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

  cargoSha256 = "sha256-VK9DObkg4trcGUXxxISCd0zqU3vc1Qt6NxqpgKIARCQ=";

  cargoPatches = [
    # there is a duplicate definition in the lock file which fails to build with buildRustPackage
    (fetchpatch {
      name = "cargo-vendor.patch";
      url = "https://github.com/timescale/promscale_extension/commit/3048bd959430e9abc2c1d5c772ab6b4fc1dc6a95.patch";
      hash = "sha256-xTk4Ml8GN06QlJdrvAdVK21r30ZR/S83y5A5jJPdOw4=";
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
