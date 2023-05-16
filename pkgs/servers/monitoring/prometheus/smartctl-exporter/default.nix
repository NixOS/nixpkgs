{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "smartctl_exporter";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-M4d8l9EbOZsi2ubyRo7KSBYewcC9NidW/Rf1QVVIvo8=";
  };

  vendorHash = "sha256-0WLI+nLhRkf1CGhSer1Jkv1nUho5sxIbTE/Mf5JmX7U=";
=======
    hash = "sha256-fc1NZ5QwzR/jJkeaDm5PMT4wBFFlqZOXKTJMBJWKJJ8=";
  };

  vendorSha256 = "sha256-lQKuT5dzjDHFpRSmcXpKD1RJDlEv+0kcxENkv3mT4FU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smartctl; };

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa Frostman ];
  };
}
