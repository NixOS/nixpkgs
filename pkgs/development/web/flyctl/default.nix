{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.238";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-dW5+Ga3/sfI33DUmJ3OwXvgbLqC1JkTXXauu0POc16s=";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "sha256-cKZk3SU/UAoA1XTegKG7/8XDNceQi+NTKML0UiiOTV0=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/superfly/flyctl/flyctl.Version=${version}" "-X github.com/superfly/flyctl/flyctl.Commit=${src.rev}" "-X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000" "-X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}
