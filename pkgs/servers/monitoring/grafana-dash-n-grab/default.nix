{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-OLMa5s3QoK+ZeU3v/mPW9tPXqKTS/f+90pPpT+nlWFU=";
  };

  vendorHash = "sha256-y5eqG0kB3kGZ2X/VR6aVT+qCVZQd2MbFDqReoPwNtO4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X github.com/esnet/gdg/version.GitCommit=${src.rev}"
  ];

  # The test suite tries to communicate with a running version of grafana locally. This fails if
  # you don't have grafana running.
  doCheck = false;

  meta = with lib; {
    description = "Grafana Dash-n-Grab (gdg) -- backup and restore Grafana dashboards, datasources, and other entities";
    license = licenses.bsd3;
    homepage = "https://github.com/esnet/gdg";
    maintainers = with maintainers; teams.bitnomial.members;
    mainProgram = "gdg";
    changelog =
      "https://github.com/esnet/gdg/releases/tag/v${version}";
  };
}
