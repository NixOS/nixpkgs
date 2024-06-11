{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "protoc-gen-go-grpc";
  version = "1.4.0";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    sha256 = "sha256-EoDXnm5qtjJKHM4TF6UQCaMkOcX/dlRjkb8mc7fUkHQ=";
  };

  vendorHash = "sha256-ZjZa31iwjxKzMvAAVMVLyQdWnyb/HsUCV/yo7a59qaw=";

  meta = with lib; {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    mainProgram = "protoc-gen-go-grpc";
    license = licenses.asl20;
    maintainers = [ maintainers.raboof ];
  };
}
