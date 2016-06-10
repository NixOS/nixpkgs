{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.12.2";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "02qqcnijv8z3736iczbx082yizpqk02g5k746k7sdgfkgyxydppk";
  };

  buildInputs = [ ncurses ];

  goDeps = ./deps.json;
  
  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf'|'$bin/bin/fzf'|" plugin/fzf.vim
    sed -i -e "s|expand('<sfile>:h:h').'/bin/fzf-tmux'|'$bin/bin/fzf-tmux'|" plugin/fzf.vim
  '';

  postInstall= ''
    cp $src/bin/fzf-tmux $bin/bin
    mkdir -p $out/share/vim-plugins
    ln -s $out/share/go/src/github.com/junegunn/fzf $out/share/vim-plugins/${name}
  '';
}
