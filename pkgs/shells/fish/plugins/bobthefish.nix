{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "bobthefish";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-bobthefish";
    rev = "72a89d424644d087c182843a48fbf0a43c796f31";
    hash = "sha256-wzC+PNpKCJy4zRAdY9wagrgUulAMb8B6lrwc106P7Zc=";
  };

  meta = {
    description = "Powerline-style, Git-aware fish theme optimized for awesome";
    homepage = "https://github.com/oh-my-fish/theme-bobthefish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      thegu5
    ];
  };
}
