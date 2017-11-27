{ stdenv, fetchFromGitHub }:

# To make use of this plugin, need to add
#   programs.zsh.interactiveShellInit = ''
#     source ${pkgs.zsh-command-time}/share/zsh-command-time/command-time.plugin.zsh
#     ZSH_COMMAND_TIME_MIN_SECONDS=3
#     ZSH_COMMAND_TIME_ECHO=1
#   '';

stdenv.mkDerivation rec {
  version = "2017-05-09";
  name = "zsh-command-time-${version}";

  src = fetchFromGitHub {
    owner = "popstas";
    repo = "zsh-command-time";
    rev = "2111361cbc88c542c834fbab7802ae5ae8339824";
    sha256 = "0hr9c7196wy9cg7vkmknszr2h446yvg9pqrq0rf3213kz074dhpg";
  };

  installPhase = ''
    install -D $src/command-time.plugin.zsh --target-directory=$out/share/zsh-command-time
  '';

  meta = with stdenv.lib; {
    description = "Plugin that output time: xx after long commands";
    homepage = https://github.com/popstas/zsh-command-time;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
