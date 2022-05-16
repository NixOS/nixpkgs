{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-mockery";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    rev = "v${version}";
    sha256 = "sha256-hBt5qtcQXLXXq2DZM8VymeHrQoRuOAFxOXeColx/bgc=";
  };

  vendorSha256 = "sha256-/ha6DCJ+vSOmfFJ+rjN6rfQ3GHZF19OQnmHjYRtSY2g=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v2/pkg/config.SemVer=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/vektra/mockery";
    description = "A mock code autogenerator for Golang";
    maintainers = with maintainers; [ fbrs ];
    mainProgram = "mockery";
    license = licenses.bsd3;
  };
}
