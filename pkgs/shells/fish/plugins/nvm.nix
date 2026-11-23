{
  buildFishPlugin,
  fetchFromGitHub,
  lib,
}:
buildFishPlugin (finalAttrs: {
  pname = "nvm";
  version = "2.2.18";
  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "nvm.fish";
    tag = finalAttrs.version;
    hash = "sha256-u3qhoYBDZ0zBHbD+arDxLMM8XoLQlNI+S84wnM3nDzg=";
  };

  meta = {
    description = "Node.js version manager you'll adore, crafted just for Fish";
    homepage = "https://github.com/jorgebucaran/nvm.fish";
    changelog = "https://github.com/jorgebucaran/nvm.fish/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    downloadPage = "https://github.com/jorgebucaran/nvm.fish/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pta2002 ];
  };
})
