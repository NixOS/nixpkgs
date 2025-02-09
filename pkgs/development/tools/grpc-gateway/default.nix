{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpc-gateway";
  version = "2.18.1";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v${version}";
    sha256 = "sha256-mbRceXqc7UmrhM2Y6JJIUvMf9YxMFMjRW7VvEa8/xHs=";
  };

  vendorHash = "sha256-zVojs4q8TytJY3myKvLdACnMFJ0iK9Cfn+aZ4d/j34s=";

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
