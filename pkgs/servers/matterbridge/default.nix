{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "matterbridge-${version}";
  version = "1.6.3";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1d2wrfq07kk5l19w2d6yyjcdvn9b39cji1k5vzsfq0xkdb6b8spb";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
