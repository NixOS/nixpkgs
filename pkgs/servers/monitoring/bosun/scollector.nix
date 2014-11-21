{ stdenv, fetchgit, fetchurl, go }:
let

in stdenv.mkDerivation rec {
  name = "scollector-20141119233025";
  src = fetchurl {
    url = https://github.com/bosun-monitor/scollector/archive/20141119233025.tar.gz;
    sha256 = "13f7hg4mswcdl76ksx8ds3297rslsswb1hq327b3xm1wyr42k6wa";
  };
  buildInputs = [ go ];

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p src/github.com/bosun-monitor
    mv scollector-20141119233025 src/github.com/bosun-monitor/scollector

    export GOPATH=$PWD
    go build -v -o scollector src/github.com/bosun-monitor/scollector/main.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp scollector $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
