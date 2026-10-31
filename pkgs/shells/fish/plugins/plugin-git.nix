{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "plugin-git";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "jhillyerd";
    repo = "plugin-git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2+CX9ZGNkois7h3m30VG19Cf4ykRdoiPpEVxJMk75I4=";
  };

  meta = {
    description = "Git plugin for fish (similar to oh-my-zsh git)";
    homepage = "https://github.com/jhillyerd/plugin-git";
    changelog = "https://github.com/jhillyerd/plugin-git/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      unsolvedcypher
    ];
  };
})
