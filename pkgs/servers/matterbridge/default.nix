{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.16.3";

  goPackagePath = "github.com/42wim/matterbridge";
  modSha256 = "1pc2p37by7wn93394cn55hf3lblplgf9wf9wib2jlbh42017m923";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "1qdlcr6hqxyvhzd92w6m22if7snc37sy7jk6rxv6g6m5g14xj1jl";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
