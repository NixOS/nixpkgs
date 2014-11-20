{ stdenv, fetchgit, fetchurl, go }:
let
  go-fs = fetchgit {
    url = git://github.com/rakyll/statik.git;
    rev = "f19d7c21cd036701d42ec176b13e0946cc9591b0";
    sha256 = "0vaa8xzkmj1dgiayg7ccrniapz4f4rhsizx2hybyc5rgmalfj9ac";
  };

in stdenv.mkDerivation rec {
  name = "bosun-20141114233454";
  src = fetchurl {
    url = https://github.com/bosun-monitor/bosun/archive/20141114233453.tar.gz;
    sha256 = "0sd4gqfclasdw3z5j67lh2i7gyxyshgakpi9bj0mb3jz3lvcz4wb";
  };
  buildInputs = [ go ];

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p src/github.com/bosun-monitor
    mv bosun-20141114233453 src/github.com/bosun-monitor/bosun

    mkdir -p src/github.com/rakyll
    ln -s ${go-fs} src/github.com/rakyll/statik

    export GOPATH=$PWD
    go build -v -o bosun src/github.com/bosun-monitor/bosun/main.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bosun $out/bin
  '';

}
