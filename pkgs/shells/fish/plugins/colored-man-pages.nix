{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "colored-man-pages";
  version = "0-unstable-2022-04-30";

  src = fetchFromGitHub {
    owner = "patrickf1";
    repo = "colored_man_pages.fish";
    rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
    sha256 = "0ifqdbaw09hd1ai0ykhxl8735fcsm0x2fwfzsk7my2z52ds60bwa";
  };

  meta = with lib; {
    description = "Fish shell plugin to colorize man pages";
    homepage = "https://github.com/PatrickF1/colored_man_pages.fish";
    license = licenses.mit;
    maintainers = [ maintainers.jocelynthode ];
  };
}
