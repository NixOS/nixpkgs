{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "protoc-gen-twirp";
  version = "8.1.3";

  src = fetchFromGitHub {
    owner = "twitchtv";
    repo = "twirp";
    rev = "v${version}";
    sha256 = "sha256-p3gHVHGBHakOOQnJAuMK7vZumNXN15mOABuEHUG0wNs=";
  };

  goPackagePath = "github.com/twitchtv/twirp";

  subPackages = [
    "protoc-gen-twirp"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Simple RPC framework with protobuf service definitions";
    mainProgram = "protoc-gen-twirp";
    homepage = "https://github.com/twitchtv/twirp";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
