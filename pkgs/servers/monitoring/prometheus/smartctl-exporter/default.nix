{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-M4d8l9EbOZsi2ubyRo7KSBYewcC9NidW/Rf1QVVIvo8=";
  };

  vendorHash = "sha256-0WLI+nLhRkf1CGhSer1Jkv1nUho5sxIbTE/Mf5JmX7U=";

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
