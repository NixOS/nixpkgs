{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.65.4";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-2W25BNj5+9ZuzPmkdTKRbRNUdOp1e3TcLaPz3ulKFYU=";
  };

  vendorHash = "sha256-qT8YhNZ+9n9+VduW8a/tr74w3OyWue7a51667Q9dMCg=";

  CGO_CFLAGS = [ "-Wno-format-security" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/tbls.commit=unspecified"
    "-X github.com/k1LoW/tbls.date=unspecified"
    "-X github.com/k1LoW/tbls.version=${src.rev}"
    "-X github.com/k1LoW/tbls/version.Version=${src.rev}"
  ];

  preCheck = ''
    # Remove tests that require additional services.
    rm -f \
       datasource/datasource_test.go \
       drivers/*/*_test.go
  '';

  passthru.tests.version = testers.testVersion {
    package = tbls;
    command = "tbls version";
    version = src.rev;
  };

  meta = with lib; {
    description = "A tool to generate documentation based on a database";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
