{ stdenv, buildGoPackage, fetchgit, pkgconfig, ffmpeg-full, graphicsmagick, ghostscript, quicktemplate,
  go-bindata, easyjson, nodePackages, cmake, emscripten }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-05-20";
  rev = "0432df41f30795cad5dc9d135ab620d5da7c7b04";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson emscripten ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bakape/meguca";
    sha256 = "0fahk5ykpah14pwgmgiajps2y3pn96wa4z34rcphkwy549ycxxd0";
    fetchSubmodules = true;
  };

  configurePhase = ''
    export HOME=$PWD
    export GOPATH=$GOPATH:$HOME/go
    ln -sf ${nodePackages.meguca}/lib/node_modules/meguca/node_modules
    sed -i "/npm install --progress false --depth 0/d" Makefile
    make generate_clean
    go generate meguca/...
  '';

  buildPhase = ''
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
