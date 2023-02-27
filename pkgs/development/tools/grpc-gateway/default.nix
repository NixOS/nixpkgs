{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpc-gateway";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v${version}";
    sha256 = "sha256-fI9C0E5sMeZ8NDH7YMpbJ1So+PQ+isswbZWd0r7unis=";
  };

  vendorHash = "sha256-JY788tDOo373ucUGzG4zNQbrGo8fdvWda/nMF0NpEE8=";

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
