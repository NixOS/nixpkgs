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
    hash = "sha256-ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
  };

  meta = {
    description = "Fish shell plugin to colorize man pages";
    homepage = "https://github.com/PatrickF1/colored_man_pages.fish";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jocelynthode ];
  };
}
