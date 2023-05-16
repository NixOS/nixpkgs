{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "unpoller";
<<<<<<< HEAD
  version = "2.8.3";
=======
  version = "2.7.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ONr8xwvCXLnAlJKbgt/O+lCEKbV2SJXW/1oJPYRtQ3s=";
  };

  vendorHash = "sha256-eLHtSEINxrqjlPyJZJwfSGA0gVaxcIolhWnqJxLXkew=";
=======
    hash = "sha256-X7ZolDmYXexmERiCUvzKqADpwT1W/pQcaIEwMzfSTR4=";
  };

  vendorHash = "sha256-VkVU+1zX8ENmq7qY7NAEQtLyqc8UNwRQF2wU65B9vpE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-w" "-s"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Version=${version}-0"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) unpoller; };

  meta = with lib; {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unpoller/unpoller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Frostman ];
  };
}
