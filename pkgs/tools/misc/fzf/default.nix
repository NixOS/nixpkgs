{ stdenv, lib, ncurses, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fzf-${version}";
  version = "0.13.5";
  rev = "${version}";

  goPackagePath = "github.com/junegunn/fzf";

  src = fetchFromGitHub {
    inherit rev;
    owner = "junegunn";
    repo = "fzf";
    sha256 = "1zfl53nv0b2wsmgbsf850yafqkx9pplpx339iiw4037msdjqhi19";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/fzf;
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
