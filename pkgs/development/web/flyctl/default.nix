{ lib, buildGoModule, fetchFromGitHub, testers, flyctl }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.346";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-CUv/zF323tplvyAfpTWGALFV3RKpkMmxiXx3gX8ZO3A=";
  };

  vendorSha256 = "sha256-x2mJ1FO/a4eMHpEPLGdatUoY+Bt0RGElENJYUEsqcMU=";

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/superfly/flyctl/internal/buildinfo.commit=${src.rev}"
    "-X github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z"
    "-X github.com/superfly/flyctl/internal/buildinfo.environment=production"
    "-X github.com/superfly/flyctl/internal/buildinfo.version=${version}"
  ];

  preBuild = ''
    go generate ./...
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    go test ./... -ldflags="-X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z'"
  '';

  passthru.tests.version = testers.testVersion {
    package = flyctl;
    command = "HOME=$(mktemp -d) flyctl version";
    version = "v${flyctl.version}";
  };

  meta = with lib; {
    description = "Command line tools for fly.io services";
    downloadPage = "https://github.com/superfly/flyctl";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse jsierles techknowlogick viraptor ];
  };
}
