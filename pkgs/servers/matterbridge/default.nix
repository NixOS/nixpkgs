{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "matterbridge-${version}";
  version = "1.4.1";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchurl {
    url = "https://github.com/42wim/matterbridge/archive/v${version}.tar.gz";
    sha256 = "0m0phv8rngrp9gfn71gd2z184n60rng1fmvmv5nkmzsclr2y7x8b";
  };

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
