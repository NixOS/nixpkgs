{ stdenv, buildGoPackage, fetchgit, pkgconfig, cmake, libcxx, libcxxabi
, ffmpeg-full, graphicsmagick, ghostscript, quicktemplate, go-bindata, easyjson
, nodePackages, emscripten }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-06-29";
  rev = "504f872ebee46b8f6c165523a9fcbcd6ddbf8dc2";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bakape/meguca";
    sha256 = "1xjhz4lh4alk30vk03l5qs0c9x6a2023d5gvq59ss8slp9zp8ssa";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson
    emscripten
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ libcxx libcxxabi ];

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
