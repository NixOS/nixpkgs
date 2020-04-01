{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.16.5";

  goPackagePath = "github.com/42wim/matterbridge";
  modSha256 = "0nnp9jxdsr2bs1pg00vd7wpv452iyxws8g3ljzypkb7hzlphcxqh";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "15wgjzy9l3xlgih2zb56l4jmval4nhcs42wn9axvz2h7kqfbmw3d";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
