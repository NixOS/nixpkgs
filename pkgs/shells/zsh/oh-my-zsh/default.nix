# This script was inspired by the ArchLinux User Repository package:
#
#   https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=oh-my-zsh-git
{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2020-10-13";
  pname = "oh-my-zsh";
  rev = "a39bee8d11aca960651403dddbb7dba38b00183e";

  src = fetchgit { inherit rev;
    url = "https://github.com/ohmyzsh/ohmyzsh";
    sha256 = "0f2f1k6s28lgxpjdgl4s7jisw6dgva9mcsqlsq0wg6041p246nai";
  };

  patches = [(fetchpatch {
    # TODO: remove once https://github.com/ohmyzsh/ohmyzsh/pull/9210 is merged
    name = "0001-pygmalion-use-pure-zsh-instead-of-perl.patch";
    url = "https://github.com/flokli/ohmyzsh/commit/299b48ce422957c0f5ca06cd5ccade55e0a08d87.patch";
    sha256 = "1cxj3c9bbcqd8zj9fccn117n2rzhx6krzbl4db059g2vsycadwmi";
  })];

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
