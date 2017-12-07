{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "elm-github-install-${version}";

  version = (import ./gemset.nix).elm_install.version;
  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "Install Elm packages from git repositories.";
    homepage    = https://github.com/gdotdesign/elm-github-install;
    license     = licenses.unfree;
    maintainers = [ maintainers.roberth ];
    platforms   = platforms.all;
  };
}
