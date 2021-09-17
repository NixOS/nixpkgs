{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-/no8bRGoKibtcjaITUuzwAbX+gPHNJROSf79iuuRwe4=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-nl8vKVhUMSO20qCDyhNkU5cghNy8vIFqSBvLk59nbWg=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
