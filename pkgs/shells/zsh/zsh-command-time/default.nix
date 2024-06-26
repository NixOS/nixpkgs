{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# To make use of this plugin, need to add
#   programs.zsh.interactiveShellInit = ''
#     source ${pkgs.zsh-command-time}/share/zsh/plugins/command-time/command-time.plugin.zsh
#     ZSH_COMMAND_TIME_COLOR="yellow"
#     ZSH_COMMAND_TIME_MIN_SECONDS=3
#     ZSH_COMMAND_TIME_ECHO=1
#   '';

stdenv.mkDerivation {
  version = "2018-04-30";
  pname = "zsh-command-time";

  src = fetchFromGitHub {
    owner = "popstas";
    repo = "zsh-command-time";
    rev = "afb4a4c9ae7ce64ca9d4f334a79a25e46daad0aa";
    sha256 = "1bvyjgz6bhgg1nwr56r50p6fblgah6yiql55pgm5abnn2h876fjq";
  };

  strictDeps = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm0444 $src/command-time.plugin.zsh --target-directory=$out/share/zsh/plugins/command-time
  '';

  meta = with lib; {
    description = "Plugin that output time: xx after long commands";
    homepage = "https://github.com/popstas/zsh-command-time";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
