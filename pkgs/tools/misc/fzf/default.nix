{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub, writeText }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.16.7";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "11ka5n7mrm5pb9riah28zyshvfz2svm4wn6fbama39yp6sc01x23";
  };

  outputs = [ "bin" "out" "man" ];

  fishHook = writeText "load-fzf-keybindings.fish" "fzf_key_bindings";

  buildInputs = [ ncurses ];

  goDeps = ./deps.nix;

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf'|'$bin/bin/fzf'|" plugin/fzf.vim
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf-tmux'|'$bin/bin/fzf-tmux'|" plugin/fzf.vim
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
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
