{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-hsx+nmkYLkSsrUEDAf5556qNLeZ3w5txFBUpDv+b3a4=";
  };

  vendorSha256 = "sha256-1WcnEl3odjxyXfSNyzPU3fa5yrF4MaEgfCAsbr3xedA=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
