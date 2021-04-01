{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "protoc-gen-twirp";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "twitchtv";
    repo = "twirp";
    rev = "v${version}";
    sha256 = "sha256-GN7akAp0zzS8wVhgXlT1ceFUFKH4Sz74XQ8ofIE8T/k=";
  };

  goPackagePath = "github.com/twitchtv/twirp";

  subPackages = [
    "protoc-gen-twirp"
    "protoc-gen-twirp_python"
  ];

  meta = with lib; {
    description = "A simple RPC framework with protobuf service definitions";
    homepage = "https://github.com/twitchtv/twirp";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
