{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.17.5";

  goPackagePath = "github.com/42wim/matterbridge";
  vendorSha256 = null;

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1p89ik5zr1qq1abd9k1xfa4j62b11zdnl2gm52y0s5yx8slap4w0";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
