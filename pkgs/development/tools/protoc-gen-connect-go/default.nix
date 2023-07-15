{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "connect-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-2U5f+VUXZ8J9K27RccKvEY7FJs57XMasKMk+xgy0LuI=";
  };

  vendorHash = "sha256-3opkr4kUD3NQNbNYOdSWIDqKbArv9OQUkBMzae1ccVY=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  meta = with lib; {
    description = "library for building browser and gRPC-compatible HTTP APIs";
    homepage = "https://github.com/bufbuild/connect-go";
    changelog = "https://github.com/bufbuild/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
}
