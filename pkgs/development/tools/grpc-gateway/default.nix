{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpc-gateway";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v${version}";
    sha256 = "sha256-Z3eZFd53c4cZG7CL3FrXQLi2n9A5TfUnZiB9KoA6sF4=";
  };

  vendorSha256 = "sha256-PKeqjr5MZWK6ILizwRJ7oy6eUj3cH9ju/55cbS5LT8M=";

  meta = with lib; {
    description =
      "A gRPC to JSON proxy generator plugin for Google Protocol Buffers";
    longDescription = ''
      This is a plugin for the Google Protocol Buffers compiler (protoc). It reads
      protobuf service definitions and generates a reverse-proxy server which
      translates a RESTful HTTP API into gRPC. This server is generated according to
      the google.api.http annotations in the protobuf service definitions.
    '';
    homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
    license = licenses.bsd3;
    maintainers = with maintainers; [ happyalu ];
  };
}
