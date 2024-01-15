{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-lb0kMIcVOZz/8s7exsrv4I7PuF/mIzrZ6TSv4cii1UY=";
  };

  vendorHash = "sha256-tiTdGoAuY+DxYvwI1glX7LqgwOI3hCfrgszV81cxkE0=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Simple, reliable, interoperable, better gRPC";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik jk ];
  };
}
