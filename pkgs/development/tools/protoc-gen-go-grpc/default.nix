{ buildGoPackage
, fetchFromGitHub
, lib
}:

buildGoPackage rec {
  pname = "protoc-gen-go-grpc";
  version = "1.1.0";

  goPackagePath = "google.golang.org/grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    sha256 = "14rjb8j6fm07rnns3dpwgkzf3y6rmia6i9n7ns6cldc5mbf7nwi3";
  };

  subPackages = [ "cmd/protoc-gen-go-grpc" ];

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "The Go language implementation of gRPC. HTTP/2 based RPC";
    license = licenses.asl20;
    maintainers = [ maintainers.raboof ];
  };
}
