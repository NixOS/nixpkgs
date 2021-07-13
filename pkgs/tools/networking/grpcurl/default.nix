{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpcurl";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = "grpcurl";
    rev = "v${version}";
    sha256 = "sha256-BxmoIGhuAt/uhHLNdMiSrNVWAoxAAMKPJ/NsXjf2ynk=";
  };

  subPackages = [ "cmd/grpcurl" ];

  vendorSha256 = "sha256-EnstvJk2kZ1Ft5xY1dO14wnmT//2K72OnDMZqeaOeQI=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers";
    homepage = "https://github.com/fullstorydev/grpcurl";
    license = licenses.mit;
    maintainers = with maintainers; [ knl ];
  };
}
