{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-73gp3UQk7D3aWK2jtMpiY4tiVhvHkTqZipoynosd3ec=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-dHh8zHtU/r6AscInfNfVFd5psys2b6D1FS02lSoiGto=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
