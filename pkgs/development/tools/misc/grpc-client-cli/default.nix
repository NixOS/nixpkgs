{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-iIF/CzNWY8XQiXQ4WFDU2mHDuNeWmAOXP16irik83FU=";
  };

  vendorHash = "sha256-6oJuyW3Yc/m7GnE2WipTUQk9eymK6xd+dT7mOVn2/vM=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
