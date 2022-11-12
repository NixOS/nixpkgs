{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "v${version}";
    sha256 = "sha256-v+WBO7gcoInI9MgEDxuz1kBSz0w5+RGpaXrqACE9WRA=";
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
