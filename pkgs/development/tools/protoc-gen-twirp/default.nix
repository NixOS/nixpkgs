{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "protoc-gen-twirp";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "twitchtv";
    repo = "twirp";
    rev = "v${version}";
    sha256 = "sha256-Nxh10jldRcNelfrLAbJanRN+YiK8uPHBw9fV1Uchbyg=";
  };

  goPackagePath = "github.com/twitchtv/twirp";

  subPackages = [
    "protoc-gen-twirp"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A simple RPC framework with protobuf service definitions";
    homepage = "https://github.com/twitchtv/twirp";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
