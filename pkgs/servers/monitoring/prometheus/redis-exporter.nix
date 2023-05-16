{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "redis_exporter";
<<<<<<< HEAD
  version = "1.54.0";
=======
  version = "1.50.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EIkMxmaugAPPeJfAA9HBbPp59bVHvgP0ZdUy0xhrrlY=";
  };

  vendorHash = "sha256-it69pime0RAhhu/qlRFGediemMllGhA3srHpGcUet7k=";
=======
    sha256 = "sha256-FP5X+2OFEFUJWtMKbVgcCkNSV3BtQyMVsXGD6dn3mjY=";
  };

  vendorHash = "sha256-Owfxy7WkucQ6BM8yjnZg9/8CgopGTtbQTTUuxoT3RRE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a redis server
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = with lib; {
    description = "Prometheus exporter for Redis metrics";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ma27 ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
