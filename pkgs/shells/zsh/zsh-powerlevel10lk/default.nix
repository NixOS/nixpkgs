{ stdenv, fetchFromGitHub }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";`

stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "2019-07-23";
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "5ef0ec415eefbc8b4431a6e4b8e2a5e0d299176a";
    sha256 = "14fdvqgqswxkdam18c2pyvkf9889p5505a59mqdq3i9qcmv72ah0";
  };

  installPhase= ''
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel9k
    install -D functions/* --target-directory=$out/share/zsh-powerlevel9k/functions
    install -D internal/* --target-directory=$out/share/zsh-powerlevel9k/internal
  '';

  meta = {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = https://github.com/romkatv/powerlevel10k;
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
    # maintainers = [ stdenv.lib.maintainers.pierrechevalier83 ];
  };
}
