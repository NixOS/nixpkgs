{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.16.6";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "0nzjbm40c4w9d0d34s5qnr9jkrh1vkn508xl2lfwfvmnzsnb9xbn";
  };

  outputs = [ "bin" "out" "man" ];

  buildInputs = [ ncurses ];

  goDeps = ./deps.nix;

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf'|'$bin/bin/fzf'|" plugin/fzf.vim
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf-tmux'|'$bin/bin/fzf-tmux'|" plugin/fzf.vim
  '';

  postInstall = ''
    cp $src/bin/fzf-tmux $bin/bin
    mkdir -p $man/share/man
    cp -r $src/man/man1 $man/share/man
    mkdir -p $out/share/vim-plugins
    ln -s $out/share/go/src/github.com/junegunn/fzf $out/share/vim-plugins/${name}

    # Make scripts readily available for sourcing from shells. Note
    # that while files there have 'completion' in their name, they are
    # not a completions scripts (so no copying to bash-completion.d and friends).
    mkdir -p $out/share/fzf
    (cd $out/share/fzf && cp -s $out/share/go/src/github.com/junegunn/fzf/shell/* .)
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    platforms = platforms.unix;
    outputsToInstall = [ "out" "bin" "man" ];
  };
}
