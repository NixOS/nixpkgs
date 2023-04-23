{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-03Uo40kz9CNK3lC91J8smDlviRNQymP95DWmIMwZF/E=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-xe3xb1+qa53Xph+CLcUqxJYeD9d4kBaY6SJfc7bhjQY=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
