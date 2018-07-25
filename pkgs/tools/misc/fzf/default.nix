{ stdenv, ncurses, buildGoPackage, fetchFromGitHub, writeText }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.17.4";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "10k21v9x82imly36lgra8a7rlvz5a1jd49db16g9xc11wx7cdg8g";
  };

  outputs = [ "bin" "out" "man" ];

  fishHook = writeText "load-fzf-keybindings.fish" "fzf_key_bindings";

  buildInputs = [ ncurses ];

  goDeps = ./deps.nix;

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$bin'|" plugin/fzf.vim

    # Original and output files can't be the same
    if cmp -s $src/plugin/fzf.vim plugin/fzf.vim; then
      echo "Vim plugin patch not applied properly. Aborting" && \
      exit 1
    fi
  '';

  preInstall = ''
    mkdir -p $bin/share/fish/vendor_functions.d $bin/share/fish/vendor_conf.d
    cp $src/shell/key-bindings.fish $bin/share/fish/vendor_functions.d/fzf_key_bindings.fish
    cp ${fishHook} $bin/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
  '';

  postInstall = ''
    cp $src/bin/fzf-tmux $bin/bin
    mkdir -p $man/share/man
    cp -r $src/man/man1 $man/share/man
    mkdir -p $out/share/vim-plugins
    ln -s $out/share/go/src/github.com/junegunn/fzf $out/share/vim-plugins/${name}

    cp -R $src/shell $bin/share/fzf
    cat <<SCRIPT > $bin/bin/fzf-share
    #!/bin/sh
    # Run this script to find the fzf shared folder where all the shell
    # integration scripts are living.
    echo $bin/share/fzf
    SCRIPT
    chmod +x $bin/bin/fzf-share
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
