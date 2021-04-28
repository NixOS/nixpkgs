{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-go";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    sha256 = "sha256-n2LHI8DXQFFWhTPOFCegBgwi/0tFvRE226AZfRW8Bnc=";
  };

  vendorSha256 = "sha256-yb8l4ooZwqfvenlxDRg95rqiL+hmsn0weS/dPv/oD2Y=";

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
