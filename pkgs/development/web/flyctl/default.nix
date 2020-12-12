{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.154";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "0hf33jm0ph4a79jg9irz0ynvdyah942cm5hb6j04hmg24x1037jm";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "0fmbwk0j2aayvi3cx8cfp4b3h89v88qm4kslbmhlj8mny9rd7lys";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/superfly/flyctl/flyctl.Version=${version} -X github.com/superfly/flyctl/flyctl.Commit=${src.rev} -X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000 -X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}
