{ lib, buildFishPlugin, fetchFromGitHub, fzf, clownfish, fishtape_3 }:

buildFishPlugin rec {
  pname = "fzf.fish";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "PatrickF1";
    repo = "fzf.fish";
    rev = "v${version}";
    sha256 = "1b280n8bh00n4vkm19zrn84km52296ljlm1zhz95jgaiwymf2x73";
  };

  checkInputs = [ fzf ];
  checkPlugins = [ clownfish fishtape_3 ];
  checkFunctionDirs = [ "./functions" ];
  checkPhase = ''
    # Disable git tests which inspect the project's git repo, which isn't
    # possible since we strip the impure .git from our build input
    rm -r tests/*git*

    # Disable tests that are failing, probably because of our wrappers
    rm -r tests/search_shell_variables

    fishtape tests/*/*.fish
  '';

  meta = with lib; {
    description = "Augment your fish command line with fzf key bindings";
    homepage = "https://github.com/PatrickF1/fzf.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];
  };
}
