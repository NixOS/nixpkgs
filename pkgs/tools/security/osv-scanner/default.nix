{ lib
, buildGoModule
, fetchFromGitHub
, testers
, osv-scanner
}:
buildGoModule rec {
  pname = "osv-scanner";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0P7mcrswWvyqv7a/jyONt/3BSim0IvQUgzjO7swTWn0=";
  };

  vendorHash = "sha256-MMEkgGyetwMEiD242CPYh619o4bo4zj87jnl7HvS0OE=";

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
