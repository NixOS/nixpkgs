{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "0.15.1";
  pname = "woodpecker-cli";
  revision = "v${version}";

  vendorSha256 = null;

  doCheck = true;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = revision;
    sha256 = "sha256-ilywzKczcER7kO19X6vhn28HieeT7ZTSsoKyu802bS0=";
  };

  buildPhase = ''
    make build-cli
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv dist/woodpecker-cli $out/bin
  '';

  meta = with lib; {
    mainProgram = "woodpecker";
    maintainers = with maintainers; [ heph2 ];
    license = licenses.asl20;
    description = "Command line client for the Woodpecker continuous integration server";
  };
}
