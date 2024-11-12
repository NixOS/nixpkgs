{ lib, buildFishPlugin, fetchFromGitHub, git, fishtape_3 }:

buildFishPlugin rec {
  pname = "pure";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "pure-fish";
    repo = "pure";
    rev = "v${version}";
    hash = "sha256-8zxqPU9N5XGbKc0b3bZYkQ3yH64qcbakMsHIpHZSne4=";
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
    homepage = "https://github.com/rafaelrinaldi/pure";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
  };
}
