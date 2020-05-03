{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.17.4";

  goPackagePath = "github.com/42wim/matterbridge";
  modSha256 = "02lhlskd8m3fvy7dr1np0pk8b2myhjqj5vw3biij1b9zxgi487w4";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1hxblf97ka2f46zy2zpv8v7kk6x9h6cpliqrjvqi00kdappxizs4";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
