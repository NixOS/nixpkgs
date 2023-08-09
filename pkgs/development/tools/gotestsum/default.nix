{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sq0ejnX7AJoPf3deBge8PMOq1NlMbw+Ljn145C5MQ+s=";
  };

  vendorHash = "sha256-zUqa6xlDV12ZV4N6+EZ7fLPsL8U+GB7boQ0qG9egvm0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gotest.tools/gotestsum/cmd.version=${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${version}";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
