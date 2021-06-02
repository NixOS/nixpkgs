{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.22.1";

  vendorSha256 = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterbridge";
    rev = "v${version}";
    sha256 = "QPi4eCxverfBwYeE1fvx2FkQucOFCQkzoq/XhV2s2Gg=";
  };

  meta = with lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
