{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "0.15.1";
  pname = "woodpecker-cli";
  revision = "v${version}";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = revision;
    sha256 = "sha256-ilywzKczcER7kO19X6vhn28HieeT7ZTSsoKyu802bS0=";
  };

  subPackages = [ "cmd/cli" ];

  meta = with lib; {
    mainProgram = "woodpecker";
    maintainers = with maintainers; [ heph2 ];
    license = licenses.asl20;
    description = "Command line client for the Woodpecker continuous integration server";
  };
}
