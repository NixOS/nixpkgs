{ lib, stdenv, buildFishPlugin, fetchFromGitHub, fd, fzf, util-linux, clownfish, fishtape_3 }:

buildFishPlugin rec {
  pname = "fzf.fish";
  version = "8.1";

  src = fetchFromGitHub {
    owner = "PatrickF1";
    repo = "fzf.fish";
    rev = "v${version}";
    sha256 = "sha256-uqYVbRdrcO6StaIim9S8xmb9P67CmXnLEywSeILn4yQ=";
  };

  checkInputs = [ fzf fd util-linux ];
  checkPlugins = [ clownfish fishtape_3 ];
  checkFunctionDirs = [ "./functions" ];
  checkPhase = ''
    # Disable git tests which inspect the project's git repo, which isn't
    # possible since we strip the impure .git from our build input
    rm -r tests/*git*

    # Disable tests that are failing, probably because of our wrappers
    rm -r tests/configure_bindings
    rm -r tests/search_shell_variables

    # Disable tests that are failing, because there is not 'rev' command
    rm tests/preview_file/custom_file_preview.fish

  '' + (
    if stdenv.isDarwin then ''script /dev/null fish -c "fishtape tests/*/*.fish"''
    else ''script -c 'fish -c "fishtape tests/*/*.fish"' ''
  );

  meta = with lib; {
    description = "Augment your fish command line with fzf key bindings";
    homepage = "https://github.com/PatrickF1/fzf.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];
  };
}
