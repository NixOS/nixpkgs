{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-go";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    sha256 = "sha256-wKJYy/9Bld6GXM1VFYXEs9//Y27eLrqDdw+a9P9EwfU=";
  };

  vendorHash = "sha256-yb8l4ooZwqfvenlxDRg95rqiL+hmsn0weS/dPv/oD2Y=";

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
