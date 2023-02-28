{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-mockery";
  version = "2.20.2";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    rev = "v${version}";
    sha256 = "sha256-MIEVAEjXM3QNz3PnjB/g5Ury+N9NJhxtcXF+SLAvqR4=";
  };

  preCheck = ''
    substituteInPlace ./pkg/generator_test.go --replace 0.0.0-dev ${version}
  '';

  ldflags = [
    "-s" "-w"
    "-X" "github.com/vektra/mockery/v2/pkg/config.SemVer=v${version}"
  ];

  CGO_ENABLED = false;

  vendorHash = "sha256-3lx3wHnPQ/slRXnlVAnI1ZqSykDXNivjwg1WUITGj64=";

  meta = with lib; {
    homepage = "https://github.com/vektra/mockery";
    description = "A mock code autogenerator for Golang";
    maintainers = with maintainers; [ fbrs ];
    mainProgram = "mockery";
    license = licenses.bsd3;
  };
}
