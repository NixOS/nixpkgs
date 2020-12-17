# This script was inspired by the ArchLinux User Repository package:
#
#   https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=oh-my-zsh-git
{ stdenv, fetchFromGitHub, nixosTests, writeScript, common-updater-scripts, git
, nix, nixfmt, jq, coreutils, gnused, curl, cacert }:

stdenv.mkDerivation rec {
  version = "2020-12-16";
  pname = "oh-my-zsh";
  rev = "b28665aebb4c1b07a57890eb59551bc51d0acf37";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    sha256 = "00m8d992jhbkd8mhm6zhirk9ga3dfzhh8idn2yp40yk7wdbzrd74";
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

  passthru = {
    tests = { inherit (nixosTests) oh-my-zsh; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        stdenv.lib.makeBinPath [
          common-updater-scripts
          curl
          cacert
          git
          nixfmt
          nix
          jq
          coreutils
          gnused
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion oh-my-zsh" | tr -d '"')"
      latestSha="$(curl -L -s https://api.github.com/repos/ohmyzsh/ohmyzsh/commits\?sha\=master\&since\=$oldVersion | jq -r '.[0].sha')"

      if [ ! "null" = "$latestSha" ]; then
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/shells/zsh/oh-my-zsh/default.nix"
        latestDate="$(curl -L -s https://api.github.com/repos/ohmyzsh/ohmyzsh/commits/$latestSha | jq '.commit.committer.date' | sed 's|"\(.*\)T.*|\1|g')"
        update-source-version oh-my-zsh "$latestSha" --version-key=rev
        update-source-version oh-my-zsh "$latestDate" --ignore-same-hash
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

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
