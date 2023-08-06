{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpc-gateway";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v${version}";
    sha256 = "sha256-oKmT1qvEWNk0q5JnzsUaCWCsllUtyIAsWXUP4DsmgnA=";
  };

  vendorHash = "sha256-YqDQ6dQQDzkehRN0jWmfjG4acB4rtL2HGHOl71IM8Lk=";

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
