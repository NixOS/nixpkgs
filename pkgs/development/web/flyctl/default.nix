{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.297";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-Ug/dGHj3prgmiIr6tkEYveTwGPUI0ivy6UtuU5QoJ2U=";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "sha256-EwMPPZOZ0xE1DKvaU7+PrUH+Ty6ut3UYJZSY4EqXFWo=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/superfly/flyctl/flyctl.Version=${version}" "-X github.com/superfly/flyctl/flyctl.Commit=${src.rev}" "-X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000" "-X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse jsierles ];
  };
}
