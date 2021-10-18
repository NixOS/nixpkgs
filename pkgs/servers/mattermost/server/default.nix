{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mattermost-server";
  version = "5.37.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kO5wSj/ApPhS2k9a9VjS3Qk55azNZeiFmevAxSkdGe0=";
  };

  vendorSha256 = null;
  doCheck = false;

  ldflags = [
    "-s" "-w" "-X github.com/mattermost/mattermost-server/v${lib.versions.major version}/model.BuildNumber=${version}"
  ];

  meta = with lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
