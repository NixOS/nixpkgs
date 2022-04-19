{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.320";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-hljQzMdA+dfZDQMqehkdZ1giv56IRygby4UF57Cogq8=";
  };

  vendorSha256 = "sha256-8+EYVaWOppzv4bV/rBWyTTdAFSx7QI0a3+oplBglxyQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/superfly/flyctl/flyctl.Commit=${src.rev}"
    "-X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000"
    "-X github.com/superfly/flyctl/flyctl.Environment=production"
    "-X github.com/superfly/flyctl/flyctl.Version=${version}"
  ];

  preBuild = ''
    go generate ./...
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    go test ./... -ldflags="-X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00+0000'"
  '';

  meta = with lib; {
    description = "Command line tools for fly.io services";
    downloadPage = "https://github.com/superfly/flyctl";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse jsierles ];
  };
}
