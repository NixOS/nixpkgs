{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mattermost-server";
  version = "5.32.1";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:BssrTfkIxUbXYXIfz9i+5b4rEYSzBim+/riK78m8Bxo=";
  };

  vendorSha256 = null;

  # buildFlagsArray = ''
  #   -ldflags=
  #   -X ${goPackagePath}/model.BuildNumber=nixpkgs-${version}
  # '';

  doCheck = false;

  meta = with lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };

}
