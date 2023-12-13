{ lib, stdenv, pkgs, buildFishPlugin, fetchFromGitHub, fd, unixtools, procps, clownfish, fishtape_3, }:
let
  # we want `pkgs.fzf`, not `fishPlugins.fzf`
  inherit (pkgs) fzf;
in
buildFishPlugin rec {
  pname = "fzf.fish";
  version = "10.2";

  src = fetchFromGitHub {
    owner = "PatrickF1";
    repo = "fzf.fish";
    rev = "v${version}";
    hash = "sha256-1/MLKkUHe4c9YLDrH+cnL+pLiSOSERbIZSM4FTG3wF0=";
  };

  nativeCheckInputs = [ fzf fd unixtools.script procps ];
  checkPlugins = [ clownfish fishtape_3 ];
  checkFunctionDirs = [ "./functions" ];
  checkPhase = ''
    # Disable git tests which inspect the project's git repo, which isn't
    # possible since we strip the impure .git from our build input
    rm -r tests/*git*
    rm -r tests/preview_changed_file/modified_path_with_spaces.fish
    rm -r tests/preview_changed_file/renamed_path_modifications.fish

    # Disable tests that are failing, probably because of our wrappers
    rm -r tests/configure_bindings
    rm -r tests/search_variables

    # Disable tests that are failing, because there is not 'rev' command
    rm tests/preview_file/custom_file_preview.fish
  '' + (
    if stdenv.isDarwin then ''script /dev/null fish -c "fishtape tests/*/*.fish"''
    else ''script -c 'fish -c "fishtape tests/*/*.fish"' ''
  );

  meta = with lib; {
    description = "Augment your fish command line with fzf key bindings";
    homepage = "https://github.com/PatrickF1/fzf.fish";
    changelog = "https://github.com/PatrickF1/fzf.fish/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien natsukium ];
  };
}
