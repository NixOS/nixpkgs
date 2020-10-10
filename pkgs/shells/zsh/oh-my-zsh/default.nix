# This script was inspired by the ArchLinux User Repository package:
#
#   https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=oh-my-zsh-git
{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2020-10-09";
  pname = "oh-my-zsh";
  rev = "1bb402190d53c118f47a0851f5714dd4faa52809";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    sha256 = "0alm6253mz8yq5l17q7hj89aa0c0nfknds9vqx8pd619bsa6kf4g";
  };

  installPhase = ''
    outdir=$out/share/oh-my-zsh
    template=templates/zshrc.zsh-template

    mkdir -p $outdir
    cp -r * $outdir
    cd $outdir

    rm LICENSE.txt
    rm -rf .git*

    chmod -R +w templates

    # Change the path to oh-my-zsh dir and disable auto-updating.
    sed -i -e "s#ZSH=\$HOME/.oh-my-zsh#ZSH=$outdir#" \
           -e 's/\# \(DISABLE_AUTO_UPDATE="true"\)/\1/' \
     $template

    chmod +w oh-my-zsh.sh

    # Both functions expect oh-my-zsh to be in ~/.oh-my-zsh and try to
    # modify the directory.
    cat >> oh-my-zsh.sh <<- EOF

    # Undefine functions that don't work on Nix.
    unfunction uninstall_oh_my_zsh
    unfunction upgrade_oh_my_zsh
    EOF

    # Look for .zsh_variables, .zsh_aliases, and .zsh_funcs, and source
    # them, if found.
    cat >> $template <<- EOF

    # Load the variables.
    if [ -f ~/.zsh_variables ]; then
        . ~/.zsh_variables
    fi

    # Load the functions.
    if [ -f ~/.zsh_funcs ]; then
      . ~/.zsh_funcs
    fi

    # Load the aliases.
    if [ -f ~/.zsh_aliases ]; then
        . ~/.zsh_aliases
    fi
    EOF
  '';

  meta = with stdenv.lib; {
    description = "A framework for managing your zsh configuration";
    longDescription = ''
      Oh My Zsh is a framework for managing your zsh configuration.

      To copy the Oh My Zsh configuration file to your home directory, run
      the following command:

        $ cp -v $(nix-env -q --out-path oh-my-zsh | cut -d' ' -f3)/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    '';
    homepage = "https://ohmyz.sh/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ scolobb nequissimus ];
  };
}
