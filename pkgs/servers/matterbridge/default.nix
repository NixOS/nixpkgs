{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "matterbridge-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1br3rf500jdklzpxg1lkagglvmqshhligfkhndi8plg9hmzpd8qp";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
