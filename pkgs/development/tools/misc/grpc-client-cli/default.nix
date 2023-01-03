{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-tvpLsiZvGneabAoTewIEnCh+0lzbr7DNepjXGg7azLc=";
  };

  vendorSha256 = "sha256-NFVDDOejclWA2WQr7CHX1CUNu+Lh5jukroSrkxby8Ag=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
