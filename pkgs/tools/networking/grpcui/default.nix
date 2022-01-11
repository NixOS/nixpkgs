{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gHzafx3nIrdLyiGlz5v6pJ8XVT+7tDN59rsdfp1V/Q0=";
  };

  vendorSha256 = "sha256-6K644KSmFEA60yMnw7GmCmycsb5x2stvc0unyV4pF9g=";

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
