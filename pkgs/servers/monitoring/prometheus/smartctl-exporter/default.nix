{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fc1NZ5QwzR/jJkeaDm5PMT4wBFFlqZOXKTJMBJWKJJ8=";
  };

  vendorSha256 = "sha256-lQKuT5dzjDHFpRSmcXpKD1RJDlEv+0kcxENkv3mT4FU=";

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
