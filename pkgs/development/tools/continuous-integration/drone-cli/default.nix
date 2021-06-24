{ lib, fetchFromGitHub, buildGoModule }:

let version = "1.2.4";
in buildGoModule rec {
  inherit version;
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "0v94rwxkbj85l3brbm792xf1rfs3vgnwpgjczwqip1gm159dpnd7";

  doCheck = false;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "14sm5k2ifvr4g9369zqgb92vrr4rc0bxf5m52l3g8bd2s8fq8nx8";
  };

  meta = with lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
