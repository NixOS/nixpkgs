{ lib, stdenv, fetchFromGitHub, substituteAll, pkgs, bash }:

<<<<<<< HEAD
=======
# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  # match gitstatus version with given `gitstatus_version`:
  # https://github.com/romkatv/powerlevel10k/blob/master/gitstatus/build.info
  gitstatus = pkgs.gitstatus.overrideAttrs (oldAtttrs: rec {
    version = "1.5.4";

    src = fetchFromGitHub {
      owner = "romkatv";
      repo = "gitstatus";
      rev = "refs/tags/v${version}";
      hash = "sha256-mVfB3HWjvk4X8bmLEC/U8SKBRytTh/gjjuReqzN5qTk=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "powerlevel10k";
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";
=======
    hash = "sha256-IiMYGefF+p4bUueO/9/mJ4mHMyJYiq+67GgNdGJ6Eew=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  buildInputs = [ bash ];

  patches = [
    (substituteAll {
      src = ./gitstatusd.patch;
      gitstatusdPath = "${gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    cp -R gitstatus $out/share/zsh-powerlevel10k/gitstatus
  '';

  meta = {
    changelog = "https://github.com/romkatv/powerlevel10k/releases/tag/v${version}";
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
<<<<<<< HEAD
    longDescription = ''
      To make use of this derivation, use
      `programs.zsh.promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`
    '';
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
