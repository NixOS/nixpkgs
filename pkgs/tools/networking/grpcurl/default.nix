{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "11wjyg5008mkpzdp6q6k6yxwxx5byas8kbp57kdi1r38pya38hna";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "0pc62dndca13jyk3bq6mp53w1ay7sfzf487m0cswvkijcsw8wk9q";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
