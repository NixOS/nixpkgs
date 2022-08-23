{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-ILQuo0UO8L71mdCgyf+rQNZ2LXzZ7kVdbL1X7Z+H9P4=";
  };

  vendorSha256 = "sha256-benXxv//bB4fcfAsZ69DZu9E+4iKQgVbaWGYcFsnyfM=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
