{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";`

stdenv.mkDerivation rec {
  name = "powerlevel9k-${version}";
  version = "2017-11-10";
  src = fetchFromGitHub {
    owner = "bhilburn";
    repo = "powerlevel9k";
    rev = "87acc51acab3ed4fd33cda2386abed6f98c80720";
    sha256 = "0v1dqg9hvycdkcvklg2njff97xwr8rah0nyldv4xm39r77f4yfvq";
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
