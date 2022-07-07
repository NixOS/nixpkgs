{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-cpk8yRDBsupI277NWYFaLCvi3ltQDLgCrcpJ/FUVi9o=";
  };

  vendorSha256 = "sha256-RwwGFBiasxMmtKMLSyAqvkozqoyzzYuslMq+HnzZUhw=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ superherointj ];
  };
}

