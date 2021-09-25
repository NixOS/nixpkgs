{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-nZaVi39dOytJTM69xpl+d9XoUt+yHdndPgY2ggfNeMQ=";
  };

  vendorSha256 = "sha256-wP5y8Ec6eSe+rdMEQQdX0fFTQ0HWuiyBRHxGlraZd+o=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X gotest.tools/gotestsum/cmd.version=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
