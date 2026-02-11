{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  git,
  fishtape_3,
}:

buildFishPlugin rec {
  pname = "pure";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "pure-fish";
    repo = "pure";
    rev = "v${version}";
    hash = "sha256-fqcIfst9YnkOi50pIUMoJJQ7s1w1Vr6hRdEFo+FWIZY=";
  };

  nativeCheckInputs = [ git ];
  checkPlugins = [ fishtape_3 ];
  checkPhase = ''
    rm tests/pure_tools_installer.test.fish
    rm tests/_pure_uninstall.test.fish

    fishtape tests/*.test.fish
  '';

  meta = {
    description = "Pretty, minimal and fast Fish prompt, ported from zsh";
    homepage = "https://github.com/pure-fish/pure";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
