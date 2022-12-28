{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-9dLILgDolHgQx33dAtYT3RJ0scWUVh52z+2Fh6FS+K4=";
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
