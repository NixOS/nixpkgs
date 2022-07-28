{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-lm+XPZB1USYV3bSYyQCgHJwG6DkhDuAbTaUycxu+CeM=";
  };

  vendorSha256 = "sha256-benXxv//bB4fcfAsZ69DZu9E+4iKQgVbaWGYcFsnyfM=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
