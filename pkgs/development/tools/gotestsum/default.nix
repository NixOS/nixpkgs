{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-EACzBakuMlwDUJTk/63OxFx3olNtyDLBYRdGE9BSSYI=";
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
