{ lib, stdenv, fetchFromGitHub, buildNpmPackage, python3, nodejs, nixosTests }:

buildNpmPackage rec {
  pname = "uptime-kuma";
  version = "1.23.11";

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    rev = version;
    hash = "sha256-PhIe2aDz6hr8001LL8N5L8jcUyzuamU0yYIVKcwmTlw=";
  };

  npmDepsHash = "sha256-Jyp/xY9K3sfqVnR7NQhgly8B54FmvnrStFO2GO2Kszs=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
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
