{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
<<<<<<< HEAD
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-sKAocI2zT2jbw42Oe7lX8J1wLVBh7RfJe1hP8aXRCuM=";
  };

  vendorHash = "sha256-3opkr4kUD3NQNbNYOdSWIDqKbArv9OQUkBMzae1ccVY=";
=======
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-KtyDnBDG67H4r/3s1ehbJhrzeG1LoU2BatWWgfTkAAs=";
  };

  vendorHash = "sha256-yCZ16rmqi8DAwIVuEgCw373bQX+cLhSNbpKutF5L2bc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

<<<<<<< HEAD
  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Simple, reliable, interoperable, better gRPC";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik jk ];
=======
  meta = with lib; {
    description = "library for building browser and gRPC-compatible HTTP APIs";
    homepage = "https://github.com/bufbuild/connect-go";
    changelog = "https://github.com/bufbuild/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
