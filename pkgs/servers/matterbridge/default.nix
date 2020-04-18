{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.17.1";

  goPackagePath = "github.com/42wim/matterbridge";
  modSha256 = "1mqp8dlwa4p70iv9ksq3pxx5zbxdh56xyksvd98zk0vkrz4f1rij";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "0xf0s1bvlzqnxz2kvqx1h9gmgqxdlf34s27s3zradi8fwd8hriv6";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
