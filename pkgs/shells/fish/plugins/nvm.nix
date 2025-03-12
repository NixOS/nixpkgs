{
  buildFishPlugin,
  fetchFromGitHub,
  lib,
}:
buildFishPlugin rec {
  pname = "nvm";
  version = "2.2.16";
  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "nvm.fish";
    tag = version;
    hash = "sha256-GTEkCm+OtxMS3zJI5gnFvvObkrpepq1349/LcEPQRDo=";
  };

  meta = {
    description = "The Node.js version manager you'll adore, crafted just for Fish";
    homepage = "https://github.com/jorgebucaran/nvm.fish";
    changelog = "https://github.com/jorgebucaran/nvm.fish/releases/tag/${version}/CHANGELOG.md";
    downloadPage = "https://github.com/jorgebucaran/nvm.fish/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pta2002 ];
  };
}
