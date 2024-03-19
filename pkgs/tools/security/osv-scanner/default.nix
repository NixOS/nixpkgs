{ lib
, buildGoModule
, fetchFromGitHub
, testers
, osv-scanner
}:
buildGoModule rec {
  pname = "osv-scanner";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/V0zn4Aic6tBJw23YJWkyeCZXf/ehIZlKWd9TZXe40Y=";
  };

  vendorHash = "sha256-wIXc0YYTdcnUBNbypVwZJ/RNTmaeMteEujmgs5WJ1g0=";

  subPackages = [
    "cmd/osv-scanner"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/osv-scanner/internal/version.OSVVersion=${version}"
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
    mainProgram = "osv-scanner";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ stehessel urandom ];
  };
}
