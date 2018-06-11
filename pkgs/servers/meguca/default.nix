{ stdenv, buildGoPackage, fetchgit, pkgconfig, ffmpeg-full, graphicsmagick, ghostscript, quicktemplate,
  go-bindata, easyjson, nodePackages, cmake, emscripten }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-06-11";
  rev = "0c10e89fade68da414a574b5b0fa2f0dba432ea8";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson emscripten ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bakape/meguca";
    sha256 = "1nw0hfa0ikbk8d5rsj3fbdwhzwnxjqkw8ypswd0hyw8nwsaxyyq8";
    fetchSubmodules = true;
  };

  buildPhase = ''
    export HOME=$PWD
    export GOPATH=$GOPATH:$HOME/go/src/github.com/bakape/meguca/go
    cd $HOME/go/src/github.com/bakape/meguca
    ln -sf ${nodePackages.meguca}/lib/node_modules/meguca/node_modules
    sed -i "/npm install --progress false --depth 0/d" Makefile
    make generate_clean
    go generate meguca/...
    go build -p $NIX_BUILD_CORES meguca
    make -j $NIX_BUILD_CORES client wasm
  '';

  installPhase = ''
    mkdir -p $bin/bin $bin/share/meguca
    cp meguca $bin/bin
    cp -r www $bin/share/meguca
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/bakape/meguca";
    description = "Anonymous realtime imageboard focused on high performance, free speech and transparent moderation";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
