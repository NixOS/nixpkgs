{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oT7CFJ266guNM6CEWn1BoNcERvLv89cVSlsrN6S/0h0=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
