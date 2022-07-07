{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "v${version}";
    sha256 = "sha256-sChXmz88AV2uw7QqIj2kwrUStcOU91Bm+QOj0GQ075Y=";
  };

  vendorSha256 = "sha256-qf9Ni2eL7gyE3/B6Lkrzsfu6ajjKUdDr7DzMJif3wbg=";

  subPackages = [ "cmd/protoc-gen-connect-go" ];

  meta = with lib; {
    description = "Simple, reliable, interoperable. A better gRPC.";
    homepage = "https://github.com/bufbuild/connect-go";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
}
