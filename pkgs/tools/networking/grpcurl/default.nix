{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-zN/vleCph919HXZZ9wsXoJBXRT6y7gjyuQxnjRMzq00=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorHash = "sha256-g5G966CuaVILGAgWunHAPrrkLjSv8pBj9R4bcLzyI+A=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
