{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-bEJjVNWd4NsUdWPqMZQ86U9F32q5M1iBRcS9MYDp9GE=";
  };

  vendorHash = "sha256-DgqCGXqEnLBxyLZJrTRZIeBIrHYA7TNMV4WTk/3IS8Y=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    mainProgram = "protoc-gen-entgrpc";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ ];
  };
}

