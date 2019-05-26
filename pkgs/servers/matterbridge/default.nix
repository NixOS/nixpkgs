{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "matterbridge-${version}";
  version = "1.11.0";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1fjpgdaq4mfgf36gzk3hhmlbpfn44b7xll2rdpy69y460jrjfg6k";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
