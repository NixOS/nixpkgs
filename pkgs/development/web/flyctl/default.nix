{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.220";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-QuNe2Q7d0WSF3pkDNKxs6b6hO9Q99oJM+ZddHD/tOaI=";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "sha256-zoheYyeofg8oVRicnZt+lFOixIH/Ssv7Kh7zC6yT/uY=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/superfly/flyctl/flyctl.Version=${version} -X github.com/superfly/flyctl/flyctl.Commit=${src.rev} -X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000 -X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}
