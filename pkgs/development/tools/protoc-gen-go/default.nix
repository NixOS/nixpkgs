{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-go";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    sha256 = "sha256-wkUvMsoJP38KMD5b3Fz65R1cnpeTtDcVqgE7tNlZXys=";
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
