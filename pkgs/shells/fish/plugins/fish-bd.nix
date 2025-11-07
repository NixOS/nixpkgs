{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gitUpdater,
}:
buildFishPlugin rec {
  pname = "fish-bd";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "0rax";
    repo = "fish-bd";
    rev = "v${version}";
    hash = "sha256-GeWjoakXa0t2TsMC/wpLEmsSVGhHFhBVK3v9eyQdzv0=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Fish plugin to quickly go back to a parent directory up in your current working directory tree";
    homepage = "https://github.com/0rax/fish-bd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
