{ lib, stdenv, mattermost-server, mattermost-webapp, buildEnv }:

buildEnv {
  name = "mattermost-${mattermost-server.version}";
  paths = [ mattermost-server mattermost-webapp ];

  meta = with lib; {
    description = "Open-source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ryantm ];
    platforms = platforms.unix;
  };
}
