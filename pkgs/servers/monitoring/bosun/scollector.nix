{ stdenv, fetchurl, go }:
stdenv.mkDerivation rec {
  name = "scollector-${version}";
  version = "20141204222654";
  src = fetchurl {
    url = "https://github.com/bosun-monitor/bosun/archive/${version}.tar.gz";
    sha256 = "1jwhfwf24zhncrirna3q1vhap4f955bqx3sws3ryk5gp1w99l36n";
  };
  buildInputs = [ go ];

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p src
    mv bosun-${version} src/bosun.org

    export GOPATH=$PWD
    go build -v -o scollector src/bosun.org/cmd/scollector/main.go
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
