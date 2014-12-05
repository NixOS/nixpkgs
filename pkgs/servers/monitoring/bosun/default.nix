{ stdenv, fetchurl, go }:
stdenv.mkDerivation rec {
  name = "bosun-${version}";
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
    go build -v -o bosun src/bosun.org/cmd/bosun/main.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bosun $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Time series alerting framework";
    longDescription = ''
      An advanced, open-source monitoring and alerting system by Stack Exchange.
    '';
    homepage = http://bosun.org;
    license = licenses.mit;
    platforms = ["x86_64-linux"];
  };
}
