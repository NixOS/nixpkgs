{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv rec {
  pname = "elm_install";
  name = "elm-github-install-${version}";

  version = (import ./gemset.nix).elm_install.version;

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "elm-github-install";

  meta = with lib; {
    description = "Install Elm packages from git repositories";
    homepage    = "https://github.com/gdotdesign/elm-github-install";
    license     = licenses.unfree;
    maintainers = with maintainers; [ roberth nicknovitski ];
    platforms   = platforms.all;
    mainProgram = "elm-install";
  };
}
