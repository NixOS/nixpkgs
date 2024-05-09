{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-OVlFOZD4+ZXRKl0Q0Dh5Etij/zeB1jTGoY8n13AyLa4=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorHash = "sha256-KsPrJC4hGrGEny8wVWE1EG00qn+b1Rrvh4qK27VzgLU=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
    mainProgram = "grpcurl";
  };
}
