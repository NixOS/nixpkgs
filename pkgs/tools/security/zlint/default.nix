{ lib
, buildGoModule
, fetchFromGitHub
, testers
, zlint
}:

buildGoModule rec {
  pname = "zlint";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zlint";
    rev = "v${version}";
    hash = "sha256-PpCA7BeamXWWRIXcoIGg2gufpqrzI6goXxQhJaH04cA=";
  };

  modRoot = "v3";

  vendorHash = "sha256-MDg09cjJ/vSLjXm4l5S4v/r2YQPV4enH8V3ByBtDVfM=";

  postPatch = ''
    # Remove a package which is not declared in go.mod.
    rm -rf v3/cmd/genTestCerts
  '';

  excludedPackages = [
    "lints"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = zlint;
    command = "zlint -version";
  };

  meta = with lib; {
    description = "X.509 Certificate Linter focused on Web PKI standards and requirements";
    longDescription = ''
      ZLint is a X.509 certificate linter written in Go that checks for
      consistency with standards (e.g. RFC 5280) and other relevant PKI
      requirements (e.g. CA/Browser Forum Baseline Requirements).
    '';
    homepage = "https://github.com/zmap/zlint";
    changelog = "https://github.com/zmap/zlint/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ baloo ];
  };
}
