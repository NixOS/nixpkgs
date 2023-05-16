{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
<<<<<<< HEAD
  version = "1.26.0";
=======
  version = "1.25.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "42wim";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-APlnJUu/ttK/S2AxO+SadU2ttmEnU+js/3GUf3x0aSQ=";
=======
    sha256 = "sha256-VqVrAmbKTfDhcvgayEE1wUeFBSTGczBrntIJQ5/uWzM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "." ];

<<<<<<< HEAD
  vendorHash = null;
=======
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
