{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-MqzuVPY/IuJWfdzHvC/keTe5yi0aMhvq8SoKDlRAI0w=";
  };

  vendorHash = "sha256-eRT1xMy9lsvF5sUF9jyDUWfNyLThIDTksaXff7xqyic=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
