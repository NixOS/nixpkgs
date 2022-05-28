{ buildGoModule, fetchFromGitHub, lib, testers, flyctl }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.330";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-lgyr2NgurOZPqJv8ZUD8ut7ELxMZqLZ+rXYTjZauv8Y=";
  };

  vendorSha256 = "sha256-T1E2VJiaGKhk/rDVKYEju3AyDPEUMGFNvj/KrMjLKEc=";

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
    maintainers = with maintainers; [ aaronjanse jsierles techknowlogick ];
  };
}
