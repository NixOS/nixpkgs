{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-CD+p/Au+MVOV93VPQL2uD8DNKl3XfoJhOjdKcx8DFwQ=";
  };

  vendorHash = "sha256-e8lz7IrGjx7oXLuNuIhwHW2IP4jfR9XB4HVDjpeH7/w=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
