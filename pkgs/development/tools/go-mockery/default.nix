{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-mockery";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    rev = "v${version}";
    sha256 = "sha256-Iut45RobHc3KZ0vzOqmQT0F8A/GSP5KCfprnmB3zFAA=";
  };

  preCheck = ''
    substituteInPlace ./pkg/generator_test.go --replace 0.0.0-dev ${version}
  '';

  ldflags = [
    "-s" "-w"
    "-X" "github.com/vektra/mockery/v2/pkg/config.SemVer=v${version}"
  ];

  CGO_ENABLED = false;

  vendorHash = "sha256-Dl8Q6fQa7BKp06a4OT82+wHYQRN1aWZ2qK25GzhOw8A=";

  meta = with lib; {
    homepage = "https://github.com/vektra/mockery";
    description = "A mock code autogenerator for Golang";
    maintainers = with maintainers; [ fbrs ];
    mainProgram = "mockery";
    license = licenses.bsd3;
  };
}
