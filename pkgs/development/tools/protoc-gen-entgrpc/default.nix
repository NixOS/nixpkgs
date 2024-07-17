{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-fXvpPH4b1JG++z0KEm9BNu5pGkneefNVvi9R5R3FqB4=";
  };

  vendorHash = "sha256-SdUs2alcc4rA6CGIrnaLO7KCseP4a0v6WE58JcRGr0k=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    mainProgram = "protoc-gen-entgrpc";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ ];
  };
}
