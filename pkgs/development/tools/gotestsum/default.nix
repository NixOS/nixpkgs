{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "1.11.0";
in
buildGoModule {
  pname = "gotestsum";
  inherit version;

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
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

  meta = {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${version}";
    description = "Human friendly `go test` runner";
    mainProgram = "gotestsum";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
