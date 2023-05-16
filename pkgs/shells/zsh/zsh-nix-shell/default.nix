{ lib, stdenv, fetchFromGitHub, bash }:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";`

stdenv.mkDerivation rec {
  pname = "zsh-nix-shell";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "zsh-nix-shell";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
=======
    sha256 = "sha256-B0mdmIqefbm5H8wSG1h41c/J4shA186OyqvivmSK42Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  buildInputs = [ bash ];
  installPhase = ''
    install -D nix-shell.plugin.zsh --target-directory=$out/share/zsh-nix-shell
    install -D scripts/* --target-directory=$out/share/zsh-nix-shell/scripts
  '';

  meta = with lib; {
    description = "zsh plugin that lets you use zsh in nix-shell shell";
    homepage = src.meta.homepage;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aw ];
  };
}
