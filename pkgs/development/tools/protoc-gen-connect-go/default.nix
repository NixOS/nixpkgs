{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-gYaOxUJzGcMKMrDdMou7mb66RVqChzSA1mc69O1zQv0=";
  };

  vendorHash = "sha256-+bWw4/ZqMeqnkXnV+vwq2mxgvew0KmLwNcu/xA2l4HI=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Simple, reliable, interoperable, better gRPC";
    mainProgram = "protoc-gen-connect-go";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik jk ];
  };
}
