# This script was inspired by the ArchLinux User Repository package:
#
#   https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=oh-my-zsh-git
{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  version = "2019-08-07";
  name = "oh-my-zsh-${version}";
  rev = "40fafe0f59371d1a9d83b83c614acfd1d740aabb";

  src = fetchgit { inherit rev;
    url = "https://github.com/robbyrussell/oh-my-zsh";
    sha256 = "0vk78dkrgbj51jvbpn337d7dnsb3p7cdj4bk92m6xqby5lmk4q01";
  };

  pathsToLink = [ "/share/oh-my-zsh" ];

  phases = "installPhase";

  installPhase = ''
  outdir=$out/share/oh-my-zsh
  template=templates/zshrc.zsh-template

  mkdir -p $outdir
  cp -r $src/* $outdir
  cd $outdir

  rm LICENSE.txt
  rm -rf .git*

  chmod -R +w templates

  # Change the path to oh-my-zsh dir and disable auto-updating.
  sed -i -e "s#ZSH=\$HOME/.oh-my-zsh#ZSH=$outdir#" \
         -e 's/\# \(DISABLE_AUTO_UPDATE="true"\)/\1/' \
   $template

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
  description     = "A framework for managing your zsh configuration";
  longDescription = ''
  Oh My Zsh is a framework for managing your zsh configuration.

  To copy the Oh My Zsh configuration file to your home directory, run
  the following command:

    $ cp -v $(nix-env -q --out-path oh-my-zsh | cut -d' ' -f3)/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  '';
  homepage        = https://ohmyz.sh/;
  license         = licenses.mit;
  platforms       = platforms.all;
  maintainers     = with maintainers; [ scolobb nequissimus ];
  };
}
