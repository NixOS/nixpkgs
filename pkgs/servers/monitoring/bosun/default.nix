{ stdenv, fetchgit, fetchurl, go }:
let
  go-fs = fetchgit {
    url = git://github.com/rakyll/statik.git;
    rev = "f19d7c21cd036701d42ec176b13e0946cc9591b0";
    sha256 = "0vaa8xzkmj1dgiayg7ccrniapz4f4rhsizx2hybyc5rgmalfj9ac";
  };

in stdenv.mkDerivation rec {
  name = "bosun-${version}";
  version = "20141119233013";
  src = fetchurl {
    url = "https://github.com/bosun-monitor/bosun/archive/${version}.tar.gz";
    sha256 = "0l16g073ixk42g3jz1r0lhmvssc0k8s1vnr9pvgxs897rzpdjjm1";
  };
  buildInputs = [ go ];

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p src/github.com/bosun-monitor
    mv bosun-${version} src/github.com/bosun-monitor/bosun

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
