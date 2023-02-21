{ lib, stdenv, fetchFromGitHub, bash }:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh/plugins/nix-shell/nix-shell.plugin.zsh";`

stdenv.mkDerivation rec {
  pname = "zsh-nix-shell";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "zsh-nix-shell";
    rev = "v${version}";
    sha256 = "sha256-IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  installPhase = ''
    install -D nix-shell.plugin.zsh --target-directory=$out/share/zsh/plugins/nix-shell
    install -D scripts/* --target-directory=$out/share/zsh/plugins/nix-shell/scripts

    #preparing a compatibility warning, and then redirect to a new location. Remove after 23.11 release.
    mkdir -p $out/share/zsh-nix-shell
    cat <<EOF > "$out/share/zsh-nix-shell/nix-shell.plugin.zsh"
    echo "WARN: zsh-nix-shell plugin files were moved to a different directory in order to make plugin installation through ohMyZsh.customPkgs possible. Please use new installation method or change source path to: $out/share/zsh/plugins/nix-shell/nix-shell.plugin.zsh"
    source $out/share/zsh/plugins/nix-shell/nix-shell.plugin.zsh
    EOF
  '';

  meta = with lib; {
    description = "zsh plugin that lets you use zsh in nix-shell shell";
    homepage = src.meta.homepage;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aw ];
  };
}
