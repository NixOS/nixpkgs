{ stdenv, fetchFromGitHub }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`

let
  version = "2019-07-28";
in

stdenv.mkDerivation rec {
  name = "powerlevel10k-${version}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "e3f5a1c3438b361d75080c3f06b95b4c98a66fee";
    sha256 = "0nv3651xysngx8q2h795z7y16vrqajy3ybhnawc8kfzid06hs8zh";
  };

  installPhase= ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D prompt_powerlevel10k_setup --target-directory=$out/share/zsh-powerlevel10k
    install -D prompt_powerlevel9k_setup --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D functions/* --target-directory=$out/share/zsh-powerlevel10k/functions
    install -D gitstatus/*.zsh --target-directory=$out/share/zsh-powerlevel10k/gitstatus
    install -D gitstatus/bin/* --target-directory=$out/share/zsh-powerlevel10k/gitstatus/bin
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
  '';

  meta = with stdenv.lib; {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = https://github.com/romkatv/powerlevel10k;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [
      maintainers.zyradyl
    ];
  };
}
