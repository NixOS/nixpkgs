{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  git,
  fishtape_3,
  nix-update-script,
}:
buildFishPlugin (finalAttrs: {
  pname = "pure";
  version = "4.19.0";

  src = fetchFromGitHub {
    owner = "pure-fish";
    repo = "pure";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8rxCmKu1pvBMm+/Ski7q3ikNnnX3gAqQ0jo0f2mIXrI=";
  };

  nativeCheckInputs = [ git ];
  checkPlugins = [ fishtape_3 ];
  checkPhase = ''
    rm tests/pure_tools_installer.test.fish
    rm tests/_pure_uninstall.test.fish

    fishtape tests/*.test.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty, minimal and fast Fish prompt, ported from zsh";
    homepage = "https://github.com/pure-fish/pure";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
})
