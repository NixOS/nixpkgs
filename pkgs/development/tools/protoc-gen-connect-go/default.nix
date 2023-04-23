{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-fWFSm6jTJZYoqRHER2o+5rcv0B5GwHx6gyK2se7Bi/o=";
  };

  vendorHash = "sha256-Bh2JCWTaML/QU/sLBsxLKMzzH++K22BTGusfcVW2GBw=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  meta = with lib; {
    description = "library for building browser and gRPC-compatible HTTP APIs";
    homepage = "https://github.com/bufbuild/connect-go";
    changelog = "https://github.com/bufbuild/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
}
