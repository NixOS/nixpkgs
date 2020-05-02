{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.123";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "1gs796n2cw8kpfsqr21zqxzp8dmnhhmjfy7vnpi838566i5ql9q3";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "10wcyxzkwvbhf86dq1rh852zgdg28draay0515zp459z34vv4zna";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/superfly/flyctl/flyctl.Version=${version} -X github.com/superfly/flyctl/flyctl.Commit=${src.rev} -X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000 -X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}