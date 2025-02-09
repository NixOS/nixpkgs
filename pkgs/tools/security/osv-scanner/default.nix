{ lib
, buildGoModule
, fetchFromGitHub
, testers
, osv-scanner
}:
buildGoModule rec {
  pname = "osv-scanner";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PLLpWr1cc+JY2N1PwlKmHw5J3F7txM4uXcu/vjGhp8o=";
  };

  vendorHash = "sha256-fQQW52xog1L31wSIlnyHPyO1nEpjqrn+PtO2B9CWZH0=";

  subPackages = [
    "cmd/osv-scanner"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=n/a"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  # Tests require network connectivity to query https://api.osv.dev.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = osv-scanner;
  };

  meta = with lib; {
    description = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ stehessel urandom ];
  };
}
