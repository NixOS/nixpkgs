{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "blackbox_exporter";
<<<<<<< HEAD
  version = "0.24.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "blackbox_exporter";
<<<<<<< HEAD
    sha256 = "sha256-eoXSBliHadRGPT6+K75p2tEjKHKXmLz4svE59yQAEuM=";
  };

  vendorHash = "sha256-yhgmJaWdYR5w5A8MVnHQS1yF6sTIMd1TOiesV4mc0Gs=";
=======
    sha256 = "sha256-im/B5PM7oSE9ejcr558sJKM67UjZUXfm5dci4ZlMycA=";
  };

  vendorSha256 = "sha256-f2m/8KvnEX0lZkmQtFOLOMj5gMUIiBKKvC+yq7QY0B4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # dns-lookup is performed for the tests
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) blackbox; };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  meta = with lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz Frostman ma27 ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
