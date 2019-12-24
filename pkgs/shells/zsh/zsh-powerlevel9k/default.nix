{ stdenv, fetchFromGitHub }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";`

stdenv.mkDerivation rec{
  pname = "powerlevel9k";
  version = "0.6.7";
  src = fetchFromGitHub {
    owner = "Powerlevel9k";
    repo = "powerlevel9k";
    rev = "v${version}";
    sha256 = "1pyg3dzr715bcm7yqanfh682yclvnb0hm6ld1x3jqx2hddqzs2js";
  };

  installPhase= ''
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel9k
    install -D functions/* --target-directory=$out/share/zsh-powerlevel9k/functions
  '';

  meta = {
    description = "A beautiful theme for zsh";
    homepage = https://github.com/bhilburn/powerlevel9k;
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.pierrechevalier83 ];
  };
}
