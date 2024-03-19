{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-APlnJUu/ttK/S2AxO+SadU2ttmEnU+js/3GUf3x0aSQ=";
  };

  subPackages = [ "." ];

  vendorHash = null;

  meta = with lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    mainProgram = "matterbridge";
  };
}
