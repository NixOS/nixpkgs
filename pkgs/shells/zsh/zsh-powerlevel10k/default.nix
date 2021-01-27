{ lib, stdenv, fetchFromGitHub, substituteAll, pkgs, bash }:

# To make use of this derivation, use
# `environment.shellPkgs =[pkgs.powerlevel10k];`

let
  # match gitstatus version with given `gitstatus_version`:
  # https://github.com/romkatv/powerlevel10k/blob/master/gitstatus/build.info
  gitstatus = pkgs.gitstatus.overrideAttrs (oldAtttrs: rec {
    version = "1.5.3";

    src = fetchFromGitHub {
      owner = "romkatv";
      repo = "gitstatus";
      rev = "v${version}";
      sha256 = "17giwdjrsmr71xskxxf506n8kaab8zx77fv267fx37ifi57nffk5";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "v${version}";
    sha256 = "0fkfh8j7rd8mkpgz6nsx4v7665d375266shl1aasdad8blgqmf0c";
  };

  strictDeps = true;
  buildInputs = [ bash ];

  patches = [
    (substituteAll {
      src = ./gitstatusd.patch;
      gitstatusdPath = "${gitstatus}/bin/gitstatusd";
    })
  ];

  outputs = [ "out" "promptInit_zsh" ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    cp -R gitstatus $out/share/zsh-powerlevel10k/gitstatus

    cp $out/share/zsh-powerlevel10k/powerlevel10k.zsh-theme $promptInit_zsh
  '';

  meta = {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.hexa ];
  };
}
