{ stdenv, fetchurl, jre, makeWrapper }:

let
  version = "0.10";
  jarName = "jmx_prometheus_httpserver-${version}-jar-with-dependencies.jar";
  mavenUrl = "mirror://maven/io/prometheus/jmx/jmx_prometheus_httpserver/${version}/${jarName}";
in stdenv.mkDerivation {
  inherit version jarName;

  name = "jmx-prometheus-httpserver-${version}";

  src = fetchurl {
    url = mavenUrl;
    sha256 = "1pvqphrirq48xhmx0aa6vkxz6qy1cx2q6jxsh7rin432iap7j62f";
  };

  buildInputs = [ jre makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/libexec
    mkdir -p $out/bin
    cp $src $out/libexec/$jarName
    makeWrapper "${jre}/bin/java" $out/bin/jmx_prometheus_httpserver --add-flags "-jar $out/libexec/$jarName"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/prometheus/jmx_exporter";
    description = "A process for exposing JMX Beans via HTTP for Prometheus consumption";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
