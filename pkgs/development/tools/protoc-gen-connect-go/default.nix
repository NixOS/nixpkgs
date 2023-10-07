{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-sKAocI2zT2jbw42Oe7lX8J1wLVBh7RfJe1hP8aXRCuM=";
  };

  vendorHash = "sha256-3opkr4kUD3NQNbNYOdSWIDqKbArv9OQUkBMzae1ccVY=";

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
