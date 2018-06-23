{ stdenv, buildGoPackage, fetchgit, pkgconfig, ffmpeg-full, graphicsmagick
, ghostscript, quicktemplate, go-bindata, easyjson, nodePackages, cmake
, emscripten }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-06-23";
  rev = "5a156e1c2a972c6d799a667f3a1a189355ea8655";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bakape/meguca";
    sha256 = "1asa5vccgl6f9c01nddpjjkw54yammbsj3wg80sbpmq9nc0djdjj";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson
    emscripten 
  ];

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
    description = "High performance anonymous realtime imageboard";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
