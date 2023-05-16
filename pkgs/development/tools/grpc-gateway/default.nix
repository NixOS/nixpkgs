{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpc-gateway";
<<<<<<< HEAD
  version = "2.17.1";
=======
  version = "2.15.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-zQAfy2dl0YtQGN9MARs9RhoqM/2GFn4iQb/X6vD8HHc=";
  };

  vendorHash = "sha256-2VkUQ6NhoRJY3qRS41igZ7U/908uWgkHaQ9V2veo1j8=";
=======
    sha256 = "sha256-0fpVSFo+o+M7vwwHIrYQZcAjdZjASdWz/cKXnPr6Je8=";
  };

  vendorHash = "sha256-WHwZ0EAJIz7mZr27x+Z7PKLLAiw1z2rQvvNynpMJQDw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
