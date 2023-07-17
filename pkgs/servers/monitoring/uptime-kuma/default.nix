{ lib, stdenv, fetchFromGitHub, fetchpatch, buildNpmPackage, python3, nodejs, nixosTests }:

buildNpmPackage rec {
  pname = "uptime-kuma";
  version = "1.21.3";

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    rev = version;
    sha256 = "sha256-hNtD8R8nDwO+uJ5WD8TxaCyYD7ESvBPmcv7iT7NAu6s=";
  };

  npmDepsHash = "sha256-GEYu04yZkLNwFG4sYujqIRU4ZCTXm4OYAydXEy4lEiA=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
    (fetchpatch {
      name = "CVE-2023-36821-CVE-2023-36822.patch";
      url = "https://github.com/louislam/uptime-kuma/commit/a0736e04b2838aae198c2110db244eab6f87757b.patch";
      hash = "sha256-uTgxc1U/ILdSzZda8XQZlxRT5vY2qVkj1J1WcOali/0=";
    })
  ];

  nativeBuildInputs = [ python3 ];

  CYPRESS_INSTALL_BINARY = 0; # Stops Cypress from trying to download binaries

  postInstall = ''
    cp -r dist $out/lib/node_modules/uptime-kuma/
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/uptime-kuma-server \
      --add-flags $out/lib/node_modules/uptime-kuma/server/server.js \
      --chdir $out/lib/node_modules/uptime-kuma
  '';

  passthru.tests.uptime-kuma = nixosTests.uptime-kuma;

  meta = with lib; {
    description = "A fancy self-hosted monitoring tool";
    homepage = "https://github.com/louislam/uptime-kuma";
    changelog = "https://github.com/louislam/uptime-kuma/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ julienmalka ];
    # FileNotFoundError: [Errno 2] No such file or directory: 'xcrun'
    broken = stdenv.isDarwin;
  };
}
