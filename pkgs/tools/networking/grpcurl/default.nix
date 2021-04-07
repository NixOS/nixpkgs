{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-ZrL23eqA56BApwUtBwL5nSAd2LZbQxthyiFBnkJ5+Zg=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-Tx00zRlzxCgyYdcYjzCxnFe8HyiitaKLcXJjYWhYSic=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
