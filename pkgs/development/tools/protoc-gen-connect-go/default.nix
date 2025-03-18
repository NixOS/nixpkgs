{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ej8ya2sKtRVRQdMr63YpPbqzwtV0ZsqO+7xiif3gFr0=";
  };

  vendorHash = "sha256-OKTRxExgJ2V3736fIVvQX3FEa44jGngwCi2D/uk0F58=";

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
