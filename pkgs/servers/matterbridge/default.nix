{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.16.3";

  goPackagePath = "github.com/42wim/matterbridge";
  modSha256 = "sha256-Q6R6AhAELirFijw5ntyjly46HCzFMpLGSJYfv864gt0=";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "sha256-VAbZSXilmmd2z2bK4/UZzOrjohDVcJHah9t3DE1mtOE=";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
