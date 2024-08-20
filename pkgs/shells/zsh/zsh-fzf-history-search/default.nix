{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation {
  pname = "zsh-fzf-history-search";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "joshskidmore";
    repo = "zsh-fzf-history-search";
    rev = "d1aae98ccd6ce153c97a5401d79fd36418cd2958";
    hash = "sha256-4Dp2ehZLO83NhdBOKV0BhYFIvieaZPqiZZZtxsXWRaQ=";
  };

  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -D zsh-fzf-history-search*.zsh  --target-directory=$out/share/zsh-fzf-history-search

    runHook postInstall
  '';

  meta = {
    description = "Simple zsh plugin that replaces Ctrl+R with an fzf-driven select which includes date/times";
    homepage = "https://github.com/joshskidmore/zsh-fzf-history-search";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
