{ lib
, buildGoModule
, fetchFromGitHub
, osv-detector
, testers
}:

buildGoModule rec {
  pname = "osv-detector";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y/9q4ZJ4vxDitqrM4hGe49iqLYk4ebhTs4jrD7P8fdw=";
  };

  vendorSha256 = "sha256-KAxpDQIRrLZIOvfW8wf0CV4Fj6l3W6nNZNCH3ZE6yJc=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = osv-detector;
    command = "osv-detector -version";
    version = "osv-detector ${version} (unknown, commit none)";
  };

  meta = with lib; {
    description = "Auditing tool for detecting vulnerabilities";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
