{ stdenv, fetchurl, glibc, patchelf }:

let
  loaderAmd64 = "${glibc}/lib/ld-linux-x86-64.so.2";
in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "grafana-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/${name}.linux-x64.tar.gz";
    sha1 = "4291aada705bb69e32bd9467fbd6d0d0789e2c59";
  };

  phases = ["unpackPhase" "patchPhase" "installPhase"];

  inherit patchelf;

  patchPhase = ''
    PATH=$patchelf/bin:$PATH
    patchelf --set-interpreter ${loaderAmd64} bin/grafana-server
  '';

  installPhase = ''
    mkdir -p $out && cp -R * $out
  '';

  meta = {
    description = "A Graphite & InfluxDB Dashboard and Graph Editor";
    homepage = http://grafana.org/;
    license = licenses.asl20;

    maintainers = [ maintainers.offline ];
  };
}
