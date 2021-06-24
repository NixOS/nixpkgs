{ lib, stdenv, fetchFromGitHub, substituteAll, pkgs }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`

let
  # match gitstatus version with given `gitstatus_version`:
  # https://github.com/romkatv/powerlevel10k/blob/master/gitstatus/build.info
  gitstatus = pkgs.gitstatus.overrideAttrs (oldAtttrs: rec {
    version = "1.3.1";

    src = fetchFromGitHub {
      owner = "romkatv";
      repo = "gitstatus";
      rev = "v${version}";
      sha256 = "03zaywncds7pjrl07rvdf3fh39gnp2zfvgsf0afqwv317sgmgpzf";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "v${version}";
    sha256 = "1z6xipd7bgq7fc03x9j2dmg3yv59xyjf4ic5f1l6l6pw7w3q4sq7";
  };

  patches = [
    (substituteAll {
      src = ./gitstatusd.patch;
      gitstatusdPath = "${gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    cp -R gitstatus $out/share/zsh-powerlevel10k/gitstatus
  '';

  meta = {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.hexa ];
  };
}
