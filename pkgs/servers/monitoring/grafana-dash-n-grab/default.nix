{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grafana-dash-n-grab";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "esnet";
    repo = "gdg";
    sha256 = "sha256-47zKZnq7ADIAti4fjGj6ctoM5Qo6UzAX1aLf87TknkQ=";
  };

  vendorHash = "sha256-XJSi+p++1QFfGk57trfIgyv0nWUm38H0n/qbJgV8lEM=";

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
