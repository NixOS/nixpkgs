{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub, fetchgit }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.13.3";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "0mfrlb91akzrj0qpjpaa9bkp6m9z95z56glamry73qy21vbnj58m";
  };

  buildInputs = [ ncurses ];

  goDeps = import ./deps.nix { inherit fetchgit; };

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf'|'$bin/bin/fzf'|" plugin/fzf.vim
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf-tmux'|'$bin/bin/fzf-tmux'|" plugin/fzf.vim
  '';

  postInstall= ''
    cp $src/bin/fzf-tmux $bin/bin
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
