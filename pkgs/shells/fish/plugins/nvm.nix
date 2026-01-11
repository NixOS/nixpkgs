{
  buildFishPlugin,
  fetchFromGitHub,
  lib,
}:
buildFishPlugin rec {
  pname = "nvm";
  version = "2.2.17";
  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "nvm.fish";
    tag = version;
    hash = "sha256-BNnoP9gLQuZQt/0SOOsZaYOexNN2K7PKWT/paS0BJJY=";
  };

  meta = {
    description = "Node.js version manager you'll adore, crafted just for Fish";
    homepage = "https://github.com/jorgebucaran/nvm.fish";
    changelog = "https://github.com/jorgebucaran/nvm.fish/releases/tag/${version}/CHANGELOG.md";
    downloadPage = "https://github.com/jorgebucaran/nvm.fish/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pta2002 ];
  };
}
