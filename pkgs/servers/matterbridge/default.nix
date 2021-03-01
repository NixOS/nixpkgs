{ lib, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.21.0";

  vendorSha256 = null;

  doCheck = false;

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "sha256-ehn6KdPpDpfdyWCVfLuZLq2dDmZXc6InlnovqNsdG6Y=";
  };

  meta = with lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
