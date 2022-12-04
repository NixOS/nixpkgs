{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "v${version}";
    sha256 = "sha256-PRJqH+uBcF9SP6ZFcZfLfqJe4LSAbhFrcdBFRhiVTGM=";
  };

  vendorSha256 = "sha256-Bh2JCWTaML/QU/sLBsxLKMzzH++K22BTGusfcVW2GBw=";

  subPackages = [ "cmd/protoc-gen-connect-go" ];

  meta = with lib; {
    description = "Simple, reliable, interoperable. A better gRPC.";
    homepage = "https://github.com/bufbuild/connect-go";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
}
