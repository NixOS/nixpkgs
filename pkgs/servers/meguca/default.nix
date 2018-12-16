{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, cmake, ffmpeg-full, ghostscript
, graphicsmagick, quicktemplate, go-bindata, easyjson, nodePackages, emscripten, opencv }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-12-06";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "meguca";
    rev = "300b007cab238838f813faa9aad6abb3f22ad4d2";
    sha256 = "1rvnvhkm8l7h9rvw9vr8pm1qrr3zz5x7vayaw0caqx99xlyp93r9";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson emscripten opencv ];

  buildPhase = ''
    export HOME=`pwd`
    export GOPATH=$GOPATH:$HOME/go/src/github.com/bakape/meguca/server
    cd $HOME/go/src/github.com/bakape/meguca
    ln -sf ${nodePackages.meguca}/lib/node_modules/meguca/node_modules
    sed -i "/npm install --progress false --depth 0/d" Makefile
    make generate_clean
    go generate meguca/...
    go build -v -p $NIX_BUILD_CORES meguca
    make -j $NIX_BUILD_CORES client
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    make -j $NIX_BUILD_CORES wasm
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
