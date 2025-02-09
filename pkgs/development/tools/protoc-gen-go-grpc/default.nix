{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "protoc-gen-go-grpc";
  version = "1.3.0";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    sha256 = "sha256-Zy0k5X/KFzCao9xAGt5DNb0MMGEyqmEsDj+uvXI4xH4=";
  };

  vendorHash = "sha256-y+/hjYUTFZuq55YAZ5M4T1cwIR+XFQBmWVE+Cg1Y7PI=";

  meta = with lib; {
    description = "The Go language implementation of gRPC. HTTP/2 based RPC";
    license = licenses.asl20;
    maintainers = [ maintainers.raboof ];
  };
}
