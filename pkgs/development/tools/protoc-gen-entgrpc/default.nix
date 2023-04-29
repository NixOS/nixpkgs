{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-5gFdfMSAb0DWCMCzG0nVGU+VWam6yC26QYUPF1YjekM=";
  };

  vendorHash = "sha256-DgqCGXqEnLBxyLZJrTRZIeBIrHYA7TNMV4WTk/3IS8Y=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ ];
  };
}

