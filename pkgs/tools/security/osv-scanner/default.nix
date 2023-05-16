{ lib
, buildGoModule
, fetchFromGitHub
, testers
, osv-scanner
}:
buildGoModule rec {
  pname = "osv-scanner";
<<<<<<< HEAD
  version = "1.3.6";
=======
  version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mvR4LqUPtmLBH9RSfVge4anwun1wHJMCuGyHGQvA56s=";
  };

  vendorHash = "sha256-oxAvpiNrdst7Y8EbSTrTEebX6+G/8K5UFwdKG+wiDQE=";
=======
    hash = "sha256-xgSRaGS09a1d1qepzvkTuMtaUHh8QsKxF7RWD+0Sepg=";
  };

  vendorHash = "sha256-9tNEPgJJ4mp4DPNgIzezS9Axed3XoJV9cyTYCOGMvgA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
