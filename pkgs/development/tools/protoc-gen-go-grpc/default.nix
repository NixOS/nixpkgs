{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "protoc-gen-go-grpc";
  version = "1.5.1";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    sha256 = "sha256-PAUM0chkZCb4hGDQtCgHF3omPm0jP1sSDolx4EuOwXo=";
  };

  vendorHash = "sha256-yn6jo6Ku/bnbSX8FL0B/Uu3Knn59r1arjhsVUkZ0m9g=";

  meta = with lib; {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    mainProgram = "protoc-gen-go-grpc";
    license = licenses.asl20;
    maintainers = [ maintainers.raboof ];
  };
}
