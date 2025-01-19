{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv rec {
  pname = "elm_install";
  name = "elm-github-install-${version}";

  version = (import ./gemset.nix).elm_install.version;

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "elm-github-install";

  meta = {
    description = "Install Elm packages from git repositories";
    homepage = "https://github.com/gdotdesign/elm-github-install";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      roberth
      nicknovitski
    ];
    platforms = lib.platforms.all;
    mainProgram = "elm-install";
  };
}
