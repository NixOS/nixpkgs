{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-r3gbQntlWZ8Y2KiJOVkpzdakKnQUX2NIhk3eAyjnIV4=";
  };

  vendorHash = "sha256-23DdG/lLwzpgSRk9S6p1aNMh+AFzhO2qX2EE1EUovz8=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
