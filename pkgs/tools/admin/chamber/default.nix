{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vyVdEMs+vtZkN0UuXGmCPNB4hsfjiiG6LeWYFW3gLiw=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-pxWsx/DURVOXGC2izKS91BhbHc220+/6t15eT4Jl128=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
