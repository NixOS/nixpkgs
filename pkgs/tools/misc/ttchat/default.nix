{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ttchat";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "atye";
    repo = "ttchat";
    rev = "v${version}";
    sha256 = "sha256-Km8aBThs2h8vVpQQaN/OuDeQcrewhP0hMMRuU8/1Ilk=";
  };

  vendorSha256 = "sha256-pJAwx7RmD2sSHsz1DxtsU7bjC/b0JujlrFeGL6zmTiI=";

  meta = with lib; {
    description = "Connect to a Twitch channel's chat from your terminal";
    homepage = "https://github.com/atye/ttchat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
