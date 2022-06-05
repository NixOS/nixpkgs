{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-dS9r738y0B+p2eoo1NV54OEeRzsj9fOs09NB3HRKmJY=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-3f/GcOonE46GjCztjShRsisS/QGPjM4IJelZ8jAiSWU=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
