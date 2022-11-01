{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.56.6";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-GscA0nLGnz8Ae6V6vBgn7TCGj9AgzrIJREqkLKsZEH0=";
  };

  vendorHash = "sha256-pmnSeQHZEtsshldfq6D/r5pMYA5ivMWkzjOq2/WseYU=";

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
