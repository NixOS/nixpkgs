{ stdenv, buildGoPackage, fetchgit, pkgconfig, ffmpeg-full, graphicsmagick, ghostscript, quicktemplate,
  go-bindata, easyjson, nodePackages, cmake, emscripten }:

buildGoPackage rec {
  name = "meguca-unstable-${version}";
  version = "2018-05-26";
  rev = "9f3d902fb899dbc874c1a91298d86fda7da59b1e";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata easyjson emscripten ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bakape/meguca";
    sha256 = "0qblllf23pxcwi5fhaq8xc77iawll7v7xpk2mf9ngks3h8p7gddq";
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
