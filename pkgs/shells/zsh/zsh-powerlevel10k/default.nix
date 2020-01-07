{ stdenv, fetchFromGitHub, substituteAll, pkgs }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`

stdenv.mkDerivation {
  pname = "powerlevel10k";
  version = "unstable-2019-12-19";
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "8ef2b737d1f6099966a1eb16bdfc90d67b367f22";
    sha256 = "02b25klkyyhpdbf2vwzzbrd8hnfjpckbpjy6532ir6jqp2n2ivpj";
  };

  patches = [
    (substituteAll {
      src = ./gitstatusd.patch;
      gitstatusdPath = "${pkgs.gitAndTools.gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    rm -r gitstatus/bin
    install -D gitstatus/* --target-directory=$out/share/zsh-powerlevel10k/gitstatus
  '';

  meta = {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.hexa ];
  };
}
