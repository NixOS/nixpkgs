{ lib, stdenv, fetchFromGitHub, buildNpmPackage, python3, nodejs, nixosTests }:

buildNpmPackage rec {
  pname = "uptime-kuma";
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.21.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-868hyugz/YJaCs4dJJ4OKHi5jx/e4ScjMBxGaNGUhe0=";
  };

  npmDepsHash = "sha256-vULtoWNqvT4RW1Q1l0+9p65cZ0TZEUnhCw0/bANsjOo=";
=======
    sha256 = "sha256-Xu5mTerhLjOMnLXhjCdnw4yaznfta3h3D9VGk12JziE=";
  };

  npmDepsHash = "sha256-J00sLDfUOIy/ZJTqKrMY1dAyE3HY9Cqm9vTEm2lmLoY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
