{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "infrastructure-agent";
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = version;
    hash = "sha256-N6WxuBwUpF0M5drif1SKNFyd6cSPa8ldKuWA6aNYATE=";
  };

  vendorHash = "sha256-dYpja3HWjnczV0CsaN7LBnT4oAnmtBY4h+cnHXWaoG4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${version}"
    "-X main.gitCommit=${src.rev}"
  ];

  CGO_ENABLED =
    if stdenv.isDarwin
    then "1"
    else "0";

  subPackages = [
    "cmd/newrelic-infra"
    "cmd/newrelic-infra-ctl"
    "cmd/newrelic-infra-service"
  ];

  meta = with lib; {
    description = "New Relic Infrastructure Agent";
    homepage = "https://github.com/newrelic/infrastructure-agent.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ DavSanchez ];
    mainProgram = "newrelic-infra";
  };
}
