{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ttchat";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "atye";
    repo = "ttchat";
    rev = "v${version}";
    sha256 = "sha256-+fPARVS1ILxrigHpvb+iNqz7Xw7+c/LmHJEeRxhCbhQ=";
  };

  vendorSha256 = "sha256-XWCjnHg0P7FCuiMjCV6ijy60h0u776GyiIC/k/KMW38=";

  meta = with lib; {
    description = "Connect to a Twitch channel's chat from your terminal";
    homepage = "https://github.com/atye/ttchat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
