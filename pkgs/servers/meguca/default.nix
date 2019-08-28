{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, cmake, ffmpeg-full
, ghostscript, graphicsmagick, quicktemplate, go-bindata, easyjson
, nodePackages, emscripten, opencv, statik }:

buildGoPackage rec {
  pname = "meguca-unstable";
  version = "2019-03-12";
  goPackagePath = "github.com/bakape/meguca";
  goDeps = ./server_deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "meguca";
    rev = "21b08de09b38918061c5cd0bbd0dc9bcc1280525";
    sha256 = "1nb3bf1bscbdma83sp9fbgvmxxlxh21j9h80wakfn85sndcrws5i";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    ffmpeg-full graphicsmagick ghostscript quicktemplate go-bindata
    easyjson emscripten opencv statik
  ];

  buildPhase = ''
    export HOME=`pwd`
    cd go/src/github.com/bakape/meguca
    ln -sf ${nodePackages.meguca}/lib/node_modules/meguca/node_modules
    sed -i "/npm install --progress false --depth 0/d" Makefile
    make -j $NIX_BUILD_CORES generate all
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
    broken = true; # Broken on Hydra since 2019-04-18:
    # https://hydra.nixos.org/build/98885902
  };
}
