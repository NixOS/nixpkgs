{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.20.3";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-aPmHvi81jqRKO3aY6bZ9bMJmk/HZVl/8MAUZN3QJByQ=";
  };

  vendorHash = "sha256-ruC/JE4+ftkzmgDxg2bRxTszjBtDtKQQGvyFD9H0O3I=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
