{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.57.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-tFUkI+QNvvlorg2xk0obeFdEVKxv0T1rXr3tZUP0sGE=";
  };

  vendorHash = "sha256-E44gUzA9FW1TM0wfjVEmF5w/bgBrockluNIDkA7/hnU=";

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
